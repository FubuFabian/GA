function [center, U, distortion] = kmeans(dataSet, clusterNum, plotOpt)
%KMEANS K-means clustering using Forgy's batch-mode method
%	Usage: [center, U, distortion] = KMEANS(dataSet, clusterNum)
%		dataSet: data set to be clustered; where each row is a sample data
%		clusterNum: number of clusters (greater than one)
%		center: final cluster centers, where each row is a center
%		U: final fuzzy partition matrix (or MF matrix)
%		distortion: values of the objective function during iterations 
%
%	Type "kmeans" for a self demo.

%	Roger Jang, 20030330

if nargin==0, selfdemo; return; end
if nargin<3, plotOpt=0; end

maxLoopCount = 100;			% Max. iteration
distortion = zeros(maxLoopCount, 1);	% Array for objective function
center = initCenter(clusterNum, dataSet)	% Initial cluster centers

if plotOpt
	plot(dataSet(:,1), dataSet(:,2), 'b.');
	centerH=line(center(:,1), center(:,2), 'color', 'r', 'marker', 'o', 'linestyle', 'none', 'linewidth', 2);
	axis image
end;

% Main loop
distMat=vecdist(center, dataSet);
for i = 1:maxLoopCount,
	[center, distortion(i), distMat, U] = updateCenter(center, dataSet, distMat);
	center
	fprintf('Iteration count = %d, distortion = %f\n', i, distortion(i));
	if plotOpt, 
		set(centerH, 'xdata', center(:,1), 'ydata', center(:,2));
		drawnow;
	end
	% check termination condition
	if i > 1,
		if abs(distortion(i-1) - distortion(i))/distortion(i-1) < eps, break; end,
	end
end
loopCount = i;	% Actual number of iterations 
distortion(loopCount+1:maxLoopCount) = [];

if plotOpt
	color = {'r', 'g', 'c', 'y', 'm', 'b', 'k'};
	figure;
	plot(dataSet(:, 1), dataSet(:, 2), 'o');
	maxU = max(U);
	clusterNum = size(center,1);
	for i=1:clusterNum,
		index = find(U(i, :) == maxU);
		colorIndex = rem(i, length(color))+1;  
		line(dataSet(index, 1), dataSet(index, 2), 'linestyle', 'none', 'marker', '*', 'color', color{colorIndex});
		line(center(:,1), center(:,2), 'color', 'r', 'marker', 'o', 'linestyle', 'none', 'linewidth', 2);
	end
	axis image;
end


% ========== subfunctions ==========
% ====== Find the initial centers
function center = initCenter(clusterNum, dataSet, method)
if nargin<3; method=4; end
switch method
	case 1
		% ====== Method 1: Randomly pick clusterNum data points as cluster centers
		dataNum = size(dataSet, 1);
		tmp = randperm(dataNum);
		index = tmp(1:clusterNum);
		center = dataSet(index, :);
	case 2
		% ====== Method 2: Choose clusterNum data points closest to mean vector
		meanVec = mean(dataSet);
		distMat = vecdist(meanVec, dataSet);
		[a,b] = sort(distMat);
		center = dataSet(b(1:clusterNum), :);
	case 3
		% ====== Method 3: Choose clusterNum data points furthest to the mean vector
		meanVec = mean(dataSet);
		distMat = vecdist(meanVec, dataSet);
		[a,b] = sort(distMat);
		b = fliplr(b);
		center = dataSet(b(1:clusterNum), :);
	case 4
		% ====== Method 4: 使用資料的前幾點作為 center
		center = dataSet(1:clusterNum, :);
	otherwise
		error('Unknown method!');
end

% ====== Find new centers
function [center, distortion, distMat, U] = updateCenter(center, dataSet, distMat)
centerNum = size(center, 1);
dataNum = size(dataSet, 1);
dim = size(dataSet, 2);
% ====== Find the U (partition matrix)
[a,b] = min(distMat);
index = b+centerNum*(0:dataNum-1);
U = zeros(size(distMat));
U(index) = ones(size(index));
% ====== Check if there is an empty group (and delete them)
index=find(sum(U,2)==0);
emptyGroupNum=length(index);
if emptyGroupNum~=0,
	fprintf('Found %d empty group(s)!', emptyGroupNum);
	U(index,:)=[];
end
% ====== Find the new centers
center = (U*dataSet)./(sum(U,2)*ones(1,dim));
distMat = vecdist(center, dataSet);
% ====== Add new centers for the deleted group
if emptyGroupNum~=0
	distortionByGroup=sum(((distMat.^2).*U)');
	[junk, index]=max(distortionByGroup);   % Find the indices of the centers to be split
	index=index(1:emptyGroupNum);
	temp=center; temp(index, :)=[];
	center=[temp; center(index,:)-eps; center(index,:)+eps];
	distMat = vecdist(center, dataSet);
	[a,b] = min(distMat);
	index = b+centerNum*(0:dataNum-1);
	U = zeros(size(distMat));
	U(index) = ones(size(index));
	center = (U*dataSet)./(sum(U,2)*ones(1,dim));
	distMat = vecdist(center, dataSet);
end
distortion = sum(sum((distMat.^2).*U));		% objective function

% ====== Self demo
function selfdemo
dataNum = 150;
data1 = ones(dataNum, 1)*[0 0] + randn(dataNum, 2)/5;
data2 = ones(dataNum, 1)*[0 1] + randn(dataNum, 2)/5;
data3 = ones(dataNum, 1)*[1 0] + randn(dataNum, 2)/5;
data4 = ones(dataNum, 1)*[1 1] + randn(dataNum, 2)/5;
dataSet = [data1; data2; data3; data4];
centerNum=8;
plotOpt=1;
[center, U, distortion] = feval(mfilename, dataSet, centerNum, plotOpt);

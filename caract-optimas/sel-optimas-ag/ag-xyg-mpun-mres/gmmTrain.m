function [M, V, W, logprob] = gmmTrain(data, gaussNum, dispOpt)
% gmmTrain: Parameter training for gaussian mixture model (GMM)
%	Usage: function [M, V, W, logprob] = gmm(data, gaussNum, dispOpt)
%		data: Each row is a data point
%		gaussNum: No. of Gaussians or initial centers
%		dispOpt: Option for displaying info during training

% Roger Jang 20000610

%if nargin==0, selfdemo; return; end % *********** ESTO LO QUITE YO******************
if nargin<3, dispOpt=0; end

maxLoopCount = 300;	% Max. iteration
minImprove = 1e-7	% Min. improvement
minVariance = 1e-6;	% Min. variance
logprob = zeros(maxLoopCount, 1);   % Array for objective function

[dataNum, dim] = size(data);
onesN1 = ones(dataNum, 1);	% N is the number of data points

% Randomly select several data points as the centers
M = data(1+floor(rand(gaussNum,1)*dataNum),:);

%if length(gaussNum)==1,
	% Using vqKmeans to find initial centers
%	fprintf('Using KMEANS to find the initial centers... ');
%	M = vqKmeansMex(data', gaussNum, 0);
	
%    fprintf('Done!\n');
%	M = M';
%else
    % gaussNum is in fact the initial centers
%	M = gaussNum;
%	gaussNum = size(M, 1);
%end

% Estimate the variance for each Gaussian, as the distance to the nearest center
V = zeros(gaussNum, 1);		% Variance for each Gaussian
for j=1:gaussNum,
	V(j) = nndist(j, M);
end
W = ones(gaussNum, 1)/gaussNum;	% Weight for each Gaussian
U = W*onesN1';			% Membership matrix

if dispOpt & dim==2, 
	figure;
	emshow(M, V, data);
end

DISTSQ = vecdist(M, data).^2;	% Distance of M to data
diff_P = inf;

fprintf('Start GMM training...\n');
for i = 1:maxLoopCount
	% Expectation step:
	% P(i,j) is the probability of data(i,:) to the j-th Gaussian
	P = onesN1*(1./(2*pi*V').^(dim/2)).*exp(-DISTSQ'./(onesN1*2*V'));
	PW = P.*(onesN1*W');
	logprob(i) = -sum(log(sum(PW')));

	if dispOpt,
		fprintf('Iteration count = %d, log prob. = %f\n',i-1, logprob(i));
	end

%	U = PW'./max(1e-10, ones(gaussNum, 1)*sum(PW, 2)');
	U = PW'./(ones(gaussNum, 1)*sum(PW, 2)');
	sum_U = sum(U, 2);
	% Maximization step:  eqns (2.96) to (2.98) from Bishop p.67:
	new_M = U*data./(sum_U*ones(1,dim));		% (2.96)
	DISTSQ = vecdist(new_M, data).^2;	% Distance of new_M to data
	new_V = 1/dim*(sum(U.*DISTSQ,2)./sum_U)';	% (2.97)
	new_W = (1/dataNum)*sum_U;			% (2.98)

	if i > 1,
		diff_P = logprob(i)-logprob(i-1);
		diff_P = sum((W - new_W).^2);
	end

	M = new_M;
	V = max(minVariance, new_V)';
	W = new_W;

	if dispOpt & dim==2, 
		emshow(M, V, data);
	end

	if (diff_P < minImprove), break, end

	% Heuristic for restarting a bump at a new location if
	% it captures less than a "fair share" of the data.
%	for j = 1:gaussNum
%		if W(j) < 1/(2*gaussNum)
%			fprintf('r(%d)\n',j);
%			fprintf('#%d was (%4.3f,%4.3f) by %4.3f\n',j,M(j,:), ...
%			sqrt(V(j)));
%			M(j,:) = data(1+floor(rand(1)*dataNum),:);
%			V(j) = nndist(j, M);
%			DISTSQ(j,:) = sum(((onesN1*M(j,:)-data).^2)');
%			fprintf('#%d now (%4.3f,%4.3f) by %4.3f\n',j,M(j,:), ...
%			sqrt(V(j)));
%			if dispOpt & dim==2, 
%				emshow(M, V, data);
%			end
%			W(j) = 1/gaussNum;
%		end
%	end
end
P = onesN1*(1./(2*pi*V').^(dim/2)).*exp(-DISTSQ'./(onesN1*2*V'));
PW = P.*(onesN1*W');
logprob(i) = -sum(log(sum(PW')));
fprintf('Iteration count = %d, log prob. = %f\n',i, logprob(i));
iter_n = i;	% Actual number of iterations
logprob(iter_n+1:maxLoopCount) = [];

% ====== Self Demo ======
%function selfdemo
%[data, gaussNum] = dcdata(2);
%[M, V, W, lp] = feval(mfilename, data, gaussNum);
%logprob = -sum(log(gmmEval(data, M, V, W)))

%point_n = 40;
%x = linspace(min(data(:,1)), max(data(:,1)), point_n);
%y = linspace(min(data(:,2)), max(data(:,2)), point_n);
%[xx, yy] = meshgrid(x, y);
%data = [xx(:) yy(:)];
%z = gmmEval(data, M, V, W);
%zz = reshape(z, point_n, point_n);
%figure;
%mesh(xx, yy, zz);
%axis tight
%box on
%rotate3d on
%figure;
%contour(xx, yy, zz, 30);
%axis image

%figure;
%plot(lp);
%xlabel('Epochs');
%ylabel('Negative Log Probability');

% ====== Other subfunctions ======
function distsq = nndist(J, MU)
%  distsq = NNDIST(J, MU)
%  Estimates an initial sigma-squared value for unit j as the 
%  minimum distance between MU(J,:) and all the other centers

gaussNum = size(MU, 1);

if gaussNum > 1
	distance = vecdist(MU(J,:), MU).^2;
	distance(J) = Inf;
	distsq = min(distance);
else
	distsq = 1;
end

% ====== Other subfunctions ======
function emshow(MU, SigmaSq, data)
% EMSHOW -- display function for EM algorithm

colordef black
plot(data(:,1), data(:,2),'.r')
axis equal
amin = min(data);
amax = max(data);
axis([amin(1) amax(1) amin(2) amax(2)])
box on
hold on

circpts = -pi:pi/20:pi;
xcirc = cos(circpts);
ycirc = sin(circpts);

Sigma = sqrt(SigmaSq);
for k = 1:length(Sigma)
	plot(xcirc*Sigma(k)+MU(k,1), ycirc*Sigma(k)+MU(k,2),'y')
end
hold off
drawnow

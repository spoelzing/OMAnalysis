function [simdata, params, probe, cluster] = genranddata2()
close all
clc

%% Set parameters

% Default settings 
defaults.dims = 3; % # of dimensions
defaults.xlim = 5000; % X limit
defaults.ylim = 5000; % Y limit
defaults.zlim = 5000; % Z limit
defaults.npoints = 10^4; % # of points
defaults.fnoise = 00; % Fraction of noise in data [0-1]
defaults.ndist = 2; % Noise distribution; 1 = Uniform, 2 = Normal
defaults.nclusters = 6; % Number of clusters
defaults.cdist = 1; % Cluster distribution; 1 = Uniform, 2 = Normal
defaults.nprobes = 1; % # of probes (to simulate multi-color labeling)
defaults.crmult = 0.0000000001; % Cluster radius multiplier [0-1]
defaults.cshape = 1; % Logical variable. 
% If 0, points are randomly distributed in all directions around centroid. If 1, clusters are distributed within a spherical volume around centroid.

% # of dimensions
params.dims = input(['Choose 2 or 3 dimensions (default = ', num2str(defaults.dims)', '):']);
if isempty(params.dims)
    params.dims = defaults.dims;
elseif ~isnumeric(params.dims)
    params.dims = defaults.dims;
elseif params.dims < 2 || params.dims > 3
    params.dims = defaults.dims;
end

% Set x, y, z dimensions
params.xlim = input(['Max x position (default = ', num2str(defaults.xlim), '):']);
if isempty(params.xlim)
    params.xlim = defaults.xlim;
elseif ~isnumeric(params.xlim)
    params.xlim = defaults.xlim;
end

params.ylim = input(['Max y position (default = ', num2str(defaults.ylim), '):']);
if isempty(params.ylim)
    params.ylim = defaults.ylim;
elseif ~isnumeric(params.ylim)
    params.ylim = defaults.ylim;
end

if params.dims == 3
   params.zlim = input(['Max z position (default = ', num2str(defaults.zlim), '):']);
    if isempty(params.zlim)
        params.zlim = defaults.zlim;
    elseif ~isnumeric(params.zlim)
        params.zlim = defaults.zlim;
    end
    params.lims = [params.xlim, params.ylim, params.zlim];
else
    params.lims = [params.xlim, params.ylim];
end

% Set # of points
params.npoints = input(['Number of points (default = ', num2str(defaults.npoints),'):']);
if isempty(params.npoints)
    params.npoints = defaults.npoints;
elseif ~isnumeric(params.npoints)
    params.npoints = defaults.npoints;
end

% Set fraction of noise within data
params.fnoise = input(['Fraction of noise in data (0-1; default = ', num2str(defaults.fnoise), '):']);
if isempty(params.fnoise)
    params.fnoise = defaults.fnoise;
elseif ~isnumeric(params.fnoise)
    params.fnoise = defaults.fnoise;
end
params.nnoisepts = round(params.fnoise * params.npoints); % # of noise points
params.ncluspts = params.npoints - params.nnoisepts; % # of cluster points

% Set noise distribution
params.ndist = input(['Choose 1. Uniform or 2. Normal distribution for noise (default = ', num2str(defaults.ndist)', '):']);
if isempty(params.ndist)
    params.ndist = defaults.ndist;
elseif ~isnumeric(params.ndist)
    params.ndist = defaults.ndist;
elseif params.ndist < 1 || params.dims > 2
    params.ndist = defaults.ndist;
end

% Set # of clusters
params.nclusters = input(['Number of clusters (default = ', num2str(defaults.nclusters), '):']);
if isempty(params.nclusters)
    params.nclusters = defaults.nclusters;
elseif ~isnumeric(params.nclusters)
    params.nclusters = defaults.nclusters;
end

% Set cluster distribution
params.cdist = input(['Choose 1. Uniform or 2. Normal distribution for clusters (default = ', num2str(defaults.cdist), '):']);
if isempty(params.cdist)
    params.cdist = defaults.cdist;
elseif ~isnumeric(params.cdist)
    params.cdist = defaults.cdist;
elseif params.cdist < 1 || params.dims > 2
    params.cdist = defaults.cdist;
end

% Cluster radius multiplier
params.crmult = input(['Set cluster radius multiplier (0-1, default = ', num2str(defaults.crmult), ')']);
if isempty(params.crmult)
    params.crmult = defaults.crmult;
elseif ~isnumeric(params.crmult)
    params.crmult = defaults.crmult;
elseif params.cdist > 1 
    params.crmult = defaults.crmult;
end

% Set number of probes
params.nprobes = input(['Number of probes (default = ', num2str(defaults.nprobes), ')']);
if isempty(params.nprobes)
    params.nprobes = defaults.nprobes;
elseif ~isnumeric(params.nprobes)
    params.nprobes = defaults.nprobes;
end

% Set cluster shape
params.cshape = input(['Constrain cluster shape (0 - no, 1 - spherical, default = ', num2str(defaults.cshape), '):']);
if isempty(params.cshape)
    params.cshape = defaults.cshape;
elseif ~isnumeric(params.cshape)
    params.cshape = defaults.cshape;
end

%% Begin generating data

simdata = []; % Array to collect simulated data
probe = []; % Array listing probe for each point
cluster = []; % Array listing cluster membership for each point, 0 signifies noise

% Generate clusters
params.centroids = zeros(params.nclusters, params.dims); % Cluster centroids
params.radii = (rand(params.nclusters, 1) .* params.crmult / 2 + params.crmult / 2) .* sqrt(sum(params.lims.^2)); % Cluster radii
params.clustersizes = rand(params.nclusters, 1);
params.clustersizes = round(params.clustersizes / sum(params.clustersizes) * params.ncluspts);
params.clustersizes(end) = params.clustersizes(end) - sum(params.clustersizes) + params.ncluspts;
params.clusterprobes = ceil(rand(params.nclusters, 1) * params.nprobes); % Randomly assign clusters to different probes

for ctr0 = 1 : params.nclusters
    cluspts = params.clustersizes(ctr0); % # of points in current cluster
    probe = [probe; ones(cluspts, 1) * params.clusterprobes(ctr0)]; %#ok<AGROW>
    cluster = [cluster; ones(cluspts, 1) * ctr0]; %#ok<AGROW>
    params.centroids(ctr0, :) = randn(1, params.dims) .* params.lims .* params.crmult; % Centroid of current cluster
    
    if params.cshape
        if params.dims == 2
            if params.ndist == 1
                clusdata = randn(cluspts, 2) .* repmat(params.radii(ctr0) / 2^0.5 * [1 1], cluspts, 1) + repmat(params.centroids(ctr0, :), cluspts, 1);
            else
                clusdata = randn(cluspts, 2) .* repmat(params.radii(ctr0) / 2^0.5 * [1 1], cluspts, 1) + repmat(params.centroids(ctr0, :), cluspts, 1);
            end
        elseif params.dims == 3
            % Randomly specify points in spherical co-ordinates to conserve cluster radius
            if params.ndist == 1
                clusazimuth = randn(cluspts, 1) * 2 * pi;
                cluselevation = randn(cluspts, 1) * 2 * pi;
                clusradius = randn(cluspts, 1) * params.radii(ctr0);
            else
                clusazimuth = randn(cluspts, 1) * 2 * pi;
                cluselevation = randn(cluspts, 1) * 2 * pi;
                clusradius = randn(cluspts, 1) * params.radii(ctr0);
            end

            % Convert co-ordinates to cartesian co-ordinates
            [cx, cy, cz] = sph2cart(clusazimuth, cluselevation, clusradius);
            clusdata = [cx, cy, cz] + repmat(params.centroids(ctr0, :), cluspts, 1); % Move cluster centroid
        end
    else
        if params.dims == 2
            scale = [params.xlim, params.ylim] ./ (params.xlim^2 + params.ylim^2)^0.5 .* params.radii(ctr0);
        elseif params.dims == 3
            scale = [params.xlim, params.ylim, params.zlim] ./ (params.xlim^2 + params.ylim^2 + params.zlim^2)^0.5 .* params.radii(ctr0);
        end
        if params.ndist == 1
            clusdata = rand(cluspts, params.dims) .* repmat(scale, cluspts, 1) + repmat(params.centroids(ctr0, :), cluspts, 1);
        else
            clusdata = randn(cluspts, params.dims) .* repmat(scale, cluspts, 1) + repmat(params.centroids(ctr0, :), cluspts, 1);
        end
    end
    eval(['clusterdata.cluster', num2str(ctr0), ' = clusdata;'])
    simdata = [simdata; clusdata]; %#ok<AGROW> % Add current cluster points to dataset
end % for loop through clusters

% Move origin back to 0
params.centroids = params.centroids - repmat(min(simdata, [], 1), params.nclusters, 1); % Adjust centroid positions
simdata = simdata - repmat(min(simdata, [], 1), length(simdata), 1); 
for ctr1 = 1 : params.nclusters
    eval(['clusdata = clusterdata.cluster', num2str(ctr1), ';'])
    clusdata = clusdata - repmat(min(simdata, [], 1), length(clusdata), 1);
    eval(['clusterdata.cluster', num2str(ctr1), ' = clusdata;'])
end

% Generate noise
if params.ndist == 1
    noise = repmat(max(simdata, [], 1), params.nnoisepts, 1) .* rand(params.nnoisepts, params.dims); % Uniformly distributed noise
else
    noise = repmat(max(simdata, [], 1), params.nnoisepts, 1) .* randn(params.nnoisepts, params.dims); % Normally distributed noise
end
simdata = [simdata; noise]; % Add noise points to dataset
clusterdata.noise = noise;
clusterdata.noiseprobes = ceil(rand(params.nnoisepts, 1) * params.nprobes); % Randomly assign noise points to different probes
probe = [probe; clusterdata.noiseprobes];
cluster = [cluster; zeros(params.nnoisepts, 1)];

% Rescale data
simdata = simdata ./ repmat(max(simdata, [], 1), length(simdata), 1) .* repmat(params.lims, length(simdata), 1); % Rescale data to specified dimensions
params.centroids = params.centroids ./ repmat(max(simdata, [], 1), params.nclusters, 1) .* repmat(params.lims, params.nclusters, 1); % Adjust centroid positions
params.radii = params.radii ./ (sum(max(simdata, [], 1).^2))^0.5 * (sum(params.lims.^2)^0.5); % Rescale cluster radii

clusterdata.noise = clusterdata.noise ./ repmat(max(simdata, [], 1), length(clusterdata.noise), 1) .* repmat(params.lims, length(clusterdata.noise), 1); % Rescale data to specified dimensions
for ctr2 = 1 : params.nclusters
    eval(['clusdata = clusterdata.cluster', num2str(ctr2), ';'])
    clusdata = clusdata ./ repmat(max(simdata, [], 1), length(clusdata), 1) .* repmat(params.lims, length(clusdata), 1); % Rescale data to specified dimensions
    eval(['clusterdata.cluster', num2str(ctr2), ' = clusdata;'])
end

%% Plot data
hf1 = figure(1);

tempdata = simdata(cluster == 0, :); % Pull out noise points
if params.dims == 2
    scatter(tempdata(:, 1), tempdata(:, 2), 'kx');
else
    scatter3(tempdata(:, 1), tempdata(:, 2), tempdata(:, 3), 'kx');
end
ha1 = gca;

hold on
col = 'rgbmcy';

for ctr3 = 1 : params.nclusters
    tempdata = simdata(cluster == ctr3, :); % Pull out current cluster
    if params.dims == 2
        scatter(tempdata(:, 1), tempdata(:, 2), [col(ctr3) 'o']);
    else
        scatter3(tempdata(:, 1), tempdata(:, 2), tempdata(:, 3), [col(ctr3) 'o']);
    end 
end
hold off
set(ha1, 'xlim', [0 params.lims(1)], 'ylim', [0 params.lims(2)], 'zlim', [0 params.lims(3)])
axis image
title('By cluster')

hf2 = figure(2);

% for ctr4 = 1 : params.nprobes
%     tempdata = simdata(probe == ctr4, :); % Pull out current probe
%     if params.dims == 2
%         scatter(tempdata(:, 1), tempdata(:, 2), [col(ctr4) 'o']);
%     else
%         scatter3(tempdata(:, 1), tempdata(:, 2), tempdata(:, 3), [col(ctr4) 'o']);
%     end
%     if ctr4 == 1
%         hold on
%     end
% end
% hold off
% ha2 = gca;
% set(ha2, 'xlim', [0 params.lims(1)], 'ylim', [0 params.lims(2)], 'zlim', [0 params.lims(3)])
% axis image
% title('By probe')
% if params.dims == 2
%     scatter(simdata(:, 1), simdata(:, 2), 'kx');
% else
%     scatter3(simdata(:, 1), simdata(:, 2), simdata(:, 3), 'kx');
% end

disp('Done.')

save simdata simdata
end


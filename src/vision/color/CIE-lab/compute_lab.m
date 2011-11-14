function compute_lab

conf.inputDir = <INPUT-DIR> ;
conf.outputDir = <OUTPUT-DIR> ;
conf.numClasses = 1 ;
conf.colorClusters = <PATH-TO-THE-COLOR-CLUSTER>
conf.numWords = <THE NUMBER OF LAB CLUSTERS>

% -------------------------------------------------------------------------
%                                                                Setup data
% -------------------------------------------------------------------------
classes = dir(conf.inputDir) ;
classes = classes([classes.isdir]) ;
classes = {classes.name} ;

colorNodes = load(colorClustersPath) ;

images = {} ;
for ci = 1:length(classes)
    ims = dir(fullfile(conf.inputDir, classes{ci}, '*.jpg'))' ;
    ims = cellfun(@(x)fullfile(classes{ci},x),{ims.name},'UniformOutput',false) ;
    images = {images{:}, ims{:}} ;
end

% -------------------------------------------------------------------------
%                                                        Compute histograms
% -------------------------------------------------------------------------

blockSize = 10 ;
listLength = length(images)/blockSize ;
histsNames = [] ;
for jj = 1:listLength
    histsNames{jj} = randChar(3) ;
end
histsNames = sort(histsNames) ;

hists = {} ;
iter = 0 ;
for ii = 1:length(images)
    if mod(ii, 100) == 0
        fprintf('Processing %s (%.2f %%)\n', images{ii}, 100 * ii / length(images)) ;
    end
    im = imread(fullfile(conf.inputDir, images{ii}));
    hists{ii - (iter * blockSize)} = getColorImage(im, colorNodes);
    if mod(ii, blockSize) == 0
        tmpHists = cat(1, hists{:}) ;
        conf.blockPath = fullfile(conf.outputDir, ['block-' histsNames{ii/blockSize} '.mat']) ;
        save(conf.blockPath, 'tmpHists') ;
        hists = {} ;
    end
end

lastHists = cat(1, hists{:}) ;
conf.blockPath = fullfile(conf.outputDir,'finalBlock.mat') ;
save(conf.blockPath, 'lastHists') ;


% -------------------------------------------------------------------------
function randString = randChar(len)
% -------------------------------------------------------------------------
% randString = randChar(len):
% generate a random string of given length
%
% input:   - len : string length
%
% output:  - random string

alphabet = 'a':'z'; % lowercase letters - 'a'..'z'
num = 1 ;

numbers = randi(numel(alphabet), [num, len] );
randString = char(alphabet(numbers));

% -------------------------------------------------------------------------
function counts = getColorImage(im, colorNodes)
% -------------------------------------------------------------------------

if(size(im,3)==3)
    [L, a, b] = rgb2lab(im);
    
    L = (L - mean(L(:)));% / std(L);
    a = (a - mean(a(:)));% / std(a);
    b = (b - mean(b(:)));% / std(b);
    
    feat = single(cat(2, L(:)/2, a(:), b(:))/100);
    
    %idx = getNearestHierarchy(feat, colorNodes);
    % leafnum = zeros(numel(colorNodes), 1);
    % leafnum([colorNodes.isleaf]) = 1:sum([colorNodes.isleaf]);
    % idx = leafnum(idx);
    
    idx = getNearest(feat, colorNodes.centers);
    
    colorim = reshape(idx, [size(im, 1) size(im, 2)]);
else
    colorim = [] ;
end

% Count how many times each cluster has been encountered in the image.
counts = zeros(1,conf.numWords) ;
for i = 1:numel(colorim)
    counts(colorim(i)) = counts(colorim(i)) + 1 ;
end
% Normalization
counts = single(counts/sum(counts)) ;

% -------------------------------------------------------------------------
function idx = getNearest(data, centers)
% -------------------------------------------------------------------------

if 0 && exist('getNearest_mex', 'file')
    idx = getNearest_mex(int32(size(data, 1)), int32(size(data, 2)), ...
        int32(size(centers, 1)), double(data)', double(centers)');
    idx = idx(:);
else
    
    if 0
        idx = kdtreeidx(double(centers), double(data));
    end
    
    centers = centers';
    centerssq = sum(centers.^2, 1);
    
    idx = zeros(size(data, 1), 1);
    for k = 1:size(data, 1)
        dist = centerssq - 2*data(k, :) * centers;
        [tmp, idx(k)] = min(dist);
    end
    
end

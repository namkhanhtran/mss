function compute_luv


conf.calDir = '/Users/eliabruni/data/esp/test/input/esp-sample-1' ;
conf.dataDir = '/Users/eliabruni/data/esp/test/ouput/luv' ;
conf.autoDownloadData = false ;
conf.numTrain = 30 ;
conf.numClasses = 1 ;
conf.numWords = 10 ;
conf.numSpatialX = 1 ;
conf.numSpatialY = 1 ;
conf.quantizer = 'kdtree' ;

conf.prefix = 'baseline' ;
conf.randSeed = 1 ;


conf.vocabPath = fullfile(conf.dataDir, [conf.prefix '-vocab.mat']) ;
conf.modelPath = fullfile(conf.dataDir, [conf.prefix '-model.mat']) ;
conf.resultPath = fullfile(conf.dataDir, [conf.prefix '-result']) ;

randn('state',conf.randSeed) ;
rand('state',conf.randSeed) ;
vl_twister('state',conf.randSeed) ;

% --------------------------------------------------------------------
%                                                           Setup data
% --------------------------------------------------------------------
classes = dir(conf.calDir) ;
classes = classes([classes.isdir]) ;
classes = {classes.name} ;

images = {} ;
imageClass = {} ;
for ci = 1:length(classes)
    ims = dir(fullfile(conf.calDir, classes{ci}, '*.jpg'))' ;
    ims = cellfun(@(x)fullfile(classes{ci},x),{ims.name},'UniformOutput',false) ;
    images = {images{:}, ims{:}} ;
    imageClass{end+1} = ci * ones(1,length(ims)) ;
end
imageClass = cat(2, imageClass{:}) ;
model.classes = classes ;

model.classes = classes ;
model.numSpatialX = conf.numSpatialX ;
model.numSpatialY = conf.numSpatialY ;
model.quantizer = conf.quantizer ;
model.vocab = [] ;

% --------------------------------------------------------------------
%                                                     Train vocabulary
% --------------------------------------------------------------------


if ~exist(conf.vocabPath)
    
    singleDescrs = {} ;
    
    imageSize = 256;
    for ii = 1:conf.numTrain
        
        im = imread(fullfile(conf.calDir, images{ii}));
        im = standarizeImage(im) ;
        if ndims(im) == 2
            im = cat(3,im,im,im);
        end
        descrs = rgb2luv(im);
       
        
        singleDescrs{ii} = vl_colsubset(single(descrs), length(descrs)) ;
        
    end

    % Quantize the descriptors to get the visual words
    singleDescrs = vl_colsubset(cat(2, singleDescrs{:}), 10e4) ;
    singleDescrs = single(singleDescrs) ;
    vocab = vl_kmeans(singleDescrs, conf.numWords, 'verbose','algorithm', 'lloyd') ;

    save(conf.vocabPath, 'vocab') ;
else
    load(conf.vocabPath) ;
end

model.vocab = vocab ;

if strcmp(model.quantizer, 'kdtree')
    model.kdtree = vl_kdtreebuild(vocab) ;
end

% --------------------------------------------------------------------
%                                           Compute spatial histograms
% --------------------------------------------------------------------

blockSize = 1000 ;
listLength = length(images)/blockSize ;
histsNames = [] ;
for jj = 1:listLength
    histsNames{jj} = randseq(30) ;
end
histsNames = sort(histsNames) ;

hists = {} ;
iter = 0 ;
for ii = 1:length(images)
    if mod(ii, 100) == 0
        fprintf('Processing %s (%.2f %%)\n', images{ii}, 100 * ii / length(images)) ;
    end
    
    im = imread(fullfile(conf.calDir, images{ii})) ;
    hists{ii - (iter * blockSize)} = getImageDescriptor(model, im);
    
    if mod(ii, blockSize) == 0
        tmpHists = cat(2, hists{:}) ;
        tmpHists = rot90(tmpHists) ;
        histName = histsNames{ii/blockSize} ;
        eval([histName ' = tmpHists;' ]) ;
        conf.prefix = histsNames{ii/blockSize} ;
        conf.histPath = fullfile(conf.dataDir, [conf.prefix '.mat']) ;
        save(conf.histPath, strcat(histsNames{ii/blockSize})) ;
        eval([histName ' = {};' ]) ;
        hists = {} ;
        tmpHists = {} ;
        histName = {} ;
        iter = iter + 1 ;
    end
end

tmpHists = cat(2, hists{:}) ;
tmpHists = rot90(tmpHists) ;

eval(['ZZZZZZZZZZZZZZZZZZZZ' '= tmpHists;' ]) ;
conf.prefix = 'ZZZZZZZZZZZZZZZZZZZZ' ;
conf.histPath = fullfile(conf.dataDir, [conf.prefix '.mat']) ;
save(conf.histPath,'ZZZZZZZZZZZZZZZZZZZZ') ;

% -------------------------------------------------------------------------
function im = standarizeImage(im)
% -------------------------------------------------------------------------

im = im2single(im) ;
im = imresize(im, [480 NaN]) ;



% -------------------------------------------------------------------------
function hist = getImageDescriptor(model, im)
% -------------------------------------------------------------------------

im = standarizeImage(im) ;

if ndims(im) == 2
    im = cat(3,im,im,im);
end

numWords = size(model.vocab, 2) ;
size(numWords)

% get luv features
descrs = rgb2luv(im);
descrs = vl_colsubset(single(descrs), length(descrs)) ;

% quantize appearance
switch model.quantizer
    case 'vq'
        [drop, binsa] = min(vl_alldist(model.vocab, single(descrs)), [], 1) ;
    case 'kdtree'
        binsa = double(vl_kdtreequery(model.kdtree, model.vocab, ...
            single(descrs),...
            'MaxComparisons', 15)) ;
end

bins = sub2ind([model.numSpatialY, model.numSpatialX, numWords], ...
    binsa) ;


hist = zeros(model.numSpatialY * model.numSpatialX * numWords, 1) ;
hist = vl_binsum(hist, ones(size(bins)), bins) ;
hist = single(hist / sum(hist)) ;

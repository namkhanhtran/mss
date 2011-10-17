function hists = compute_gist

conf.calDir = '/Users/eliabruni/data/esp/test/input/esp-sample-1' ;
conf.dataDir = '/Users/eliabruni/data/esp/test/ouput/gist' ;
conf.numClasses = 1 ;

conf.prefix = 'baseline' ;
conf.randSeed = 1 ;

conf.modelPath = fullfile(conf.dataDir, [conf.prefix '-model.mat']) ;
conf.resultPath = fullfile(conf.dataDir, [conf.prefix '-result']) ;


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

% --------------------------------------------------------------------
%                                           Compute spatial histograms
% --------------------------------------------------------------------




blockSize = 10 ;
listLength = length(images)/blockSize ;
histsNames = [] ;
for jj = 1:listLength
    histsNames{jj} = randseq(30) ;
end
histsNames = sort(histsNames) ;


hists = {} ;
iter = 0 ;

% Parameters:
Nblocks = 4;
orientationsPerScale = [8 8 4];
numberBlocks = 4;
imageSize = 256;
for ii = 1:length(images)
    if mod(ii, 10) == 0
        fprintf('Processing %s (%.2f %%)\n', images{ii}, 100 * ii / length(images)) ;
    end
    
    im = imread(fullfile(conf.calDir, images{ii})) ;
    im = imresize(im, [imageSize imageSize], 'bilinear') ;
    
    % Precompute filter transfert functions (only need to do this one, unless image size is changes):
    %createGabor(orientationsPerScale, imageSize); % this shows the filters
    G = createGabor(orientationsPerScale, imageSize);
    
    % Computing gist requires 1) prefilter image, 2) filter image and collect
    % output energies
    output = prefilt(double(im), 4) ;
    
    hists{ii - (iter * blockSize)} = gistGabor(output, Nblocks, G) ;
    a = gistGabor(output, Nblocks, G) ;
    size(a)

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
function im = standardizeImage(im)
% -------------------------------------------------------------------------

% im = rgb2gray(im) ;
%im = im2bw(im) ;

if size(im,1) > 480, im = imresize(im, [480 NaN]) ; end



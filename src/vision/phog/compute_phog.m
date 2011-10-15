function hists = compute_phog

conf.calDir = '/Users/eliabruni/data/esp/test/input/esp-sample-1' ;
conf.dataDir = '/Users/eliabruni/data/esp/test/ouput/phog' ;
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

% phog settings
bin = 8;
angle = 360;
L=3;
roi = [1;225;1;30];


blockSize = 100 ;
listLength = length(images)/blockSize ;
histsNames = [] ;
for jj = 1:listLength
    histsNames{jj} = randseq(30) ;
end
histsNames = sort(histsNames) ;


hists = {} ;
iter = 0 ;
imageSize = 256;
for ii = 1:length(images)
    if mod(ii, 10) == 0
        fprintf('Processing %s (%.2f %%)\n', images{ii}, 100 * ii / length(images)) ;
    end
    
    %hists{ii - (iter * blockSize)} = anna_phog(fullfile(conf.calDir, images{ii}),bin, angle, L, roi) ;
    
    im = imread(fullfile(conf.calDir, images{ii})) ;
    im = imresize(im, [imageSize imageSize], 'bilinear') ;
    siz = size(im) ;
    
    %hists{ii - (iter * blockSize)} = anna_phog(im, 8, 360, 3, [1;30;1;30]) ;
    %a = anna_phog(im, 8, 360, 3, [1;30;1;30]) ;
    hists{ii - (iter * blockSize)} = anna_phog(im, 8, 360, 3, [1;siz(1);1;siz(2)]) ;
    %size(a)
    
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



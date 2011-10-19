
function compute_low_level


% TODO: still problems with bw while extrcacting layout

conf.calDir        = '/Users/eliabruni/data/mart/images' ;
conf.layoutDir     = '/Users/eliabruni/data/esp/test/ouput/layout' ;
conf.brightnessDir = '/Users/eliabruni/data/esp/test/ouput/brightness' ;
conf.spectralDir   = '/Users/eliabruni/data/esp/test/ouput/spectral' ;
conf.dittoDir      = '/Users/eliabruni/data/esp/test/ouput/ditto' ;

conf.numClasses = 1 ;

conf.prefix = 'baseline' ;

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

% --------------------------------------------------------------------
%                                                     Compute features
% --------------------------------------------------------------------


% compute max height and width among the images
heights = [];
widths = [];
for ii = 1:length(images)
    im = imread(fullfile(conf.calDir, images{ii}));
    heights = [heights size(im,1)];
    widths = [widths size(im,2)];
end
maxWidth = max(widths);
maxHeight = max(heights);


blockSize = 10 ;
listLength = length(images)/blockSize ;
histsNames = [] ;
for jj = 1:listLength
    histsNames{jj} = randseq(30) ;
end
histsNames = sort(histsNames) ;
layouts =      {} ;
brightnesses = {} ;
spectrals    = {} ;
dittos       = {} ;
iter = 0 ;
imageSize = 256;
for ii = 1:length(images)
    if mod(ii, 1) == 0
        fprintf('Processing %s (%.2f %%)\n', images{ii}, 100 * ii / length(images)) ;
    end
    im = imread(fullfile(conf.calDir, images{ii}));
    im = imresize(im, [imageSize imageSize], 'bilinear') ;
    %lay = computeLayout(im) ;
    %size(lay)
    %layouts{ii - (iter * blockSize)}      = computeLayout(im) ;
    brightnesses{ii - (iter * blockSize)} = computeBrightness(im) ;
    %br = computeBrightness(im) ;
    %size(br)
    spectrals{ii - (iter * blockSize)}    = computeSpectral(im, maxWidth) ;
    %sp = computeSpectral(im, maxWidth) ;
    %size(sp)
    dittos{ii - (iter * blockSize)}       = computeDitto(im, maxHeight) ;
    %di = computeDitto(im, maxHeight) ;
    %size(di)
    
    if mod(ii, blockSize) == 0
        %tmpLayouts      = cat(1, layouts{:}) ;
        %tmpHists = rot90(tmpHists) ;
        %layoutsName      = histsNames{ii/blockSize} ;
        %eval([layoutsName      ' = tmpLayouts;' ]) ;
        %conf.prefix = histsNames{ii/blockSize} ;
        %conf.histPath = fullfile(conf.layoutDir, [conf.prefix '.mat']) ;
        %save(conf.histPath, strcat(histsNames{ii/blockSize})) ;
        %eval([layoutsName   ' = {};' ]) ;
        
        
        
        %hists = {} ;
        %tmpHists = {} ;
        %histName = {} ;

        
        
        % 2
        tmpBrightnesses = cat(1, brightnesses{:}) ;
        brightnessesName = histsNames{ii/blockSize} ;
        eval([brightnessesName ' = tmpBrightnesses;' ]) ;
        conf.prefix = histsNames{ii/blockSize} ;
        conf.histPath = fullfile(conf.brightnessDir, [conf.prefix '.mat']) ;
        save(conf.histPath, strcat(histsNames{ii/blockSize})) ;
        %eval([layoutsName   ' = {};' ]) ;
        
        % 3
        tmpSpectrals    = cat(1, spectrals{:}) ;
        spectralsName    = histsNames{ii/blockSize} ;
        eval([spectralsName    ' = tmpSpectrals;' ]) ;
        conf.prefix = histsNames{ii/blockSize} ;
        conf.histPath = fullfile(conf.spectralDir, [conf.prefix '.mat']) ;
        save(conf.histPath, strcat(histsNames{ii/blockSize})) ;
        eval([spectralsName ' = {};' ]) ;
        
        % 4
        tmpDittos       = cat(1, dittos{:}) ;
        dittosName       = histsNames{ii/blockSize} ;
        eval([dittosName       ' = tmpDittos;' ]) ;
        conf.prefix = histsNames{ii/blockSize} ;
        conf.histPath = fullfile(conf.dittoDir, [conf.prefix '.mat']) ;
        save(conf.histPath, strcat(histsNames{ii/blockSize})) ;
        eval([dittosName    ' = {};' ]) ;
        
        iter = iter + 1 ;
        
    end
    
end


% -------------------------------------------------------------------------
function layoutFeatures = computeLayout(im)
% -------------------------------------------------------------------------
% extract thumbnail (square, low resolution version of image) and take greyscale + 3 layers as features

thumbNailSize = 4;

thumbnail = uint8(round(imresize(single(im),[thumbNailSize thumbNailSize])));
if ndims(im) == 2
    layoutFeatures = [reshape(uint8(thumbnail),1,[]) reshape(thumbnail,1,[])];
else
layoutFeatures = [reshape(uint8(round(mean(thumbnail,3))),1,[]) reshape(thumbnail,1,[])];
end


% -------------------------------------------------------------------------
function brightnessFeatures = computeBrightness(im)
% -------------------------------------------------------------------------
% extract and normalise brightness features for a particular colour layer, given a choice of the number
% of bins (this is done four times, and features are concatenated into brightnessFeatures)

smoothSpectrumWidth = 20;
binWidth = power(2,4); % by eye, four or five seems best...
brightnessBinCentres = [0:binWidth:255]+binWidth/2;
rgb = 'krgb'; % color codes
numPixels = numel(im)/3;

brightnessFeatures = [];
for l=[0:3]
    if l == 0 || ndims(im) == 2
        L = mean(im,3);
    else
        %subplot(4,4,l*4+1)
        L = im(:,:,l); % colour layer
        %imagesc(L)
        %eval(char(strcat('colormap(',rgbCMs(l),')'))) % sets globally for
        %figure. See for solution:
        %   http://www.mathworks.com/support/tech-notes/1200/1215.html
        %colorbar
    end
    brightHist = hist(double(L(:)),brightnessBinCentres)/numPixels;
    %subplot(4,4,l*4+2)
    %bar(brightHist,rgb(l+1))
    %ylim([0,min([1 binWidth/32])])
    %xlim([0,256/binWidth+1])
    brightnessFeatures = [brightnessFeatures brightHist];
end

% -------------------------------------------------------------------------
function hSpectralFeatures = computeSpectral(im, maxWidth)
% -------------------------------------------------------------------------
% extract and normalise horizontal spectral features
smoothSpectrumWidth = 20;
hSpectralFeatures = [];
for l=[0:3]
    if l == 0 || ndims(im) == 2
        L = mean(im,3);
    else
        %subplot(4,4,l*4+1)
        L = im(:,:,l); % colour layer
        %imagesc(L)
        %eval(char(strcat('colormap(',rgbCMs(l),')'))) % sets globally for
        %figure. See for solution:
        %   http://www.mathworks.com/support/tech-notes/1200/1215.html
        %colorbar
    end
    hD = mean(abs(fft(L',maxWidth)')); % ,maxWidth)')); % horizontal magnitude decomposition
    % note - taking abs(mean( gives much noisier result - no idea why
    hD = hD(2:ceil(length(hD)/2)); % take first half, ignoring scalar comp.
    % taking whole thing puts up performance a wee bit, but the different measures end up at much higher mutual correlations - which is what we should expect
    %hD = log(hD);
    hD = hD/norm(hD); % normalise to unit length
    hD = conv(ones(1,smoothSpectrumWidth)/smoothSpectrumWidth,hD); % moving average
    hSpectralFeatures = [hSpectralFeatures hD];
    %hD = hD(smoothSpectrumWidth:end-smoothSpectrumWidth);
end

% -------------------------------------------------------------------------
function vSpectralFeatures = computeDitto(im, maxHeight)
% -------------------------------------------------------------------------
% ditto for vertical features
smoothSpectrumWidth = 20;
vSpectralFeatures = [];
for l=[0:3]
    if l == 0 || ndims(im) == 2
        L = mean(im,3);
    else
        %subplot(4,4,l*4+1)
        L = im(:,:,l); % colour layer
        %imagesc(L)
        %eval(char(strcat('colormap(',rgbCMs(l),')'))) % sets globally for
        %figure. See for solution:
        %   http://www.mathworks.com/support/tech-notes/1200/1215.html
        %colorbar
    end
    vD = mean(abs(fft(L,maxHeight)),2); %,maxHeight))); % vertical magnitude decomposition
    vD = vD(2:ceil(length(vD)/2)); % take first half, ignoring scalar comp.
    %vD = log(vD);
    vD = vD/norm(vD); % normalise to unit length
    vD = conv(ones(1,smoothSpectrumWidth)/smoothSpectrumWidth,vD); % moving average ..
    vSpectralFeatures = [vSpectralFeatures vD'];
end


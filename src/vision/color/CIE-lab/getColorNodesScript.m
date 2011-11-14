% getColorNodesScript

conf.inputDir = <PATH-TO-THE-IMAGES> ;
conf.outputDir = <CLUSTERS-PATH> ;
conf.numWords = <THE-NUMBER-OF-LAB-CLUSTERS> ;
% The number of train the model
conf.numTrain = <A-NUMBER> ;

fn = dir(fullfile(inputDir, '*.jpg')) ;
fn = {fn.name} ;

npts = 1000 ;

rp = randperm(numel(fn)) ;
rp = rp(1:conf.numTrain) ;

clear feat ;
for f = 1:numel(rp)
    
    disp(num2str(f))
    
    im = imread(fullfile(inputDir, fn{rp(f)})) ;
    [L,a,b] = rgb2lab(im) ;
   
    %L = (L - mean(L(:)));% / std(L) ;
    %a = (a - mean(a(:)));% / std(a) ;
    %b = (b - mean(b(:)));% / std(b) ;        
    
    feat{f} = single(cat(2, L(:)/2, a(:), b(:))/100) ;   
    
    pts = randperm(size(feat{f}, 1)) ;
    feat{f} = feat{f}(pts(1:npts), :) ;
end
    
data = cat(1, feat{:}) ;

nsplits = 8 ;
nrepeat = 3 ;
varianceTarget = 0.90 ;
%colorNodes = hierarchicalKmeans(data, nsplits, nrepeat, conf.numWords, varianceTarget) ;
centers = kmeans_fast2(data, maxnodes, nrepeat) ;
save (outputDir, 'centers') ;
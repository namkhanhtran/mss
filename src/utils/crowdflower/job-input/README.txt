Steps to prepare a crowdflower job (to be translated into a wiki page):

1. Extract randomly n labels from the original label/image data set (e.g. MIR Flickr)
	==> add random.sh code to this directory

2. Filter out empty labels
	==> add unix code to do this

3. From the original data set copy all the images correspondent to the survived labels into 'labels' dir

4. Create csv file to upload on crowflower website 
	==> create_csv.py 

5. Create some gold standard on the crowdflower website	

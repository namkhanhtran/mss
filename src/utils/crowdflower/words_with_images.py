import glob, os, shutil, sys


def filter_dataset(dataset_path):
    '''
    This program assign uuid names for images and labels of the given directory.
    Images will have '.jpg' extension, labels '.txt' extension.
    Dataset_path must contain one folder called 'original_data', with two subfolders 'images' and 'labels'.
    '''
    

    preprocessed_path = os.path.join(dataset_path, 'uuid')
    os.mkdir(preprocessed_path)
    os.mkdir(os.path.join(preprocessed_path, 'labels'))
    os.mkdir(os.path.join(preprocessed_path, 'images'))
    num_files = len([f for f in os.listdir(os.path.join(dataset_path, 'data/20k-labels'))])

    # create a unique name for each label/image
    print num_files
    UUIDS = []
    for ii in range(0, num_files):
        UUIDS.append(get_random_string(32))
    UUIDS.sort()
    count = 0
    words_with_images = {}

    for file_path in glob.glob(os.path.join(dataset_path, 'data/20k-labels/*.txt')):
	file = open(file_path, "r")
	for token in file:
	    #print token
	    # check if the label contains at least one word of words_list
	    #if token in list:

	    file_name = os.path.basename(file_path)
           
            image_name = file_name[:-4] 
            image_path = os.path.join('/mnt/8tera/test-marco/image-and-text/elia/mir/original-data/all-images', image_name)
            label = str(UUIDS[count]) 
            image = str(UUIDS[count]) + '.jpg'
	    shutil.copy(str(file_path), os.path.join(preprocessed_path,'labels', label))
            shutil.copy(str(image_path), os.path.join(preprocessed_path,'images', image))
	    count += 1
	    break
        file.close()

def get_random_string(word_len):
    word = ''
    for i in range(word_len):
        word += random.choice('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789')
    return word



if __name__ =="__main__":
    dataset_path = sys.argv[1]
    filter_dataset(dataset_path)

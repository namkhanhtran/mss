import glob, os, shutil, sys

"""
This code create a directory with the images associated with
the given labels.
    
Usage:
@param1: dataset directory where you have the labels and you want also the images
@param2: path to all the images form which to pick the desired ones

"""

def extract_images(dataset_path, all_images_path):
    images_path = os.path.join(dataset_path, 'images')
    os.mkdir(images_path)
    for label_path in glob.glob(os.path.join(dataset_path, 'labels/*.txt')):
	label_name = os.path.basename(label_path)
	image_name = 'im' + label_name[+4:-3] + 'jpg'
	image_path = os.path.join(images_path, image_name)
	shutil.copy(os.path.join(all_images_path, image_name), image_path)

if __name__ =="__main__":
    _dataset_path    = sysargv[1]
    _all_images_path = sysargv[2]

    extract_images(_dataset_path, _all_images_path)

import sys, glob, os, shutil

"""
This program simply copy to the given output directory only the tags and images
within the CF cleaned data

Usage:
@param1: images directory
@param2: labels directory
@param3: output directory

"""

def create_common_data(cleaned_tags_path, not_cleaned_path, ou_path):
    for label_path in glob.glob(os.path.join(cleaned_tags_path) + '/*'):
	label_name  = os.path.basename(label_path)
	image_name  = 'im' + label_name[+4:-4] + '.jpg'
	#label_path  = not_cleaned_path  + '/' + 'labels/' + label_name
	image_path  = not_cleaned_path  + '/' + 'images/' + image_name
	#shutil.copy(label_path, ou_path + '/labels/' + label_name)
	shutil.copy(image_path, ou_path + '/images/' + image_name)


if __name__ =="__main__":
    _cleaned_tags_path = sys.argv[1]
    _not_cleaned_path  = sys.argv[2]
    _ou_path           = sys.argv[3]

    create_common_data(_cleaned_tags_path, _not_cleaned_path, _ou_path)	 

#!/bin/bash

# .--. .--. .---.   .--.            .                            
# |   )|   :|      :                |                            
# |--' |   ||---   |    .--..-.  .-.|.-. .-. .--.                
# |    |   ;|      :    |  (   )(   |-.'(.-' |                   
# '    '--' '       `--''   `-'`-`-''  `-`--''                   
# .           .   .                      .-.      .  .           
# |            \ /            o         (   )    _|__|_          
# |.-. .  .o    : .-.  .--.   ..    ._   `-.  .-. |  |  .-. .--. 
# |   )|  |     |(   ) |  |   | \  /    (   )(.-' |  | (   )|  | 
# '`-' `--|o    ' `-'`-'  `--' `-`'      `-'  `--'`-'`-'`-' '  `-
#         ;                                                      
#      `-' 
       
pdf_path="/tmp/crack_me.pdf" #path to pdf file you want to crack
pdf_name="$(basename -- $pdf_path)" #the name of the pdf file
list_folder='/Users/yanivsetton/Desktop/workspace/scripts/words_gen/list' #the path to word list
mkdir -p $list_folder/splited_files #create folder for seperating the file it its too large
mkdir -p /tmp/result # create result folder for the password file
amount_of_rows="5000" # the amount of rows to split the file
splited_folder="$list_folder/splited_files" # create internal folder the splitted files
rm -rf $splited_folder/* | echo "No folder found" # delete if there is a splitted folder before
split -l $amount_of_rows $list_folder/*.txt $splited_folder/ # split file into multiple files to reduce hack time

for file in $splited_folder/* # change splitted files to formateed with txt prefix
do
    mv "$file" "$file.txt"
done

# the loop for each file to run container to save time
for f in $splited_folder/*
do
  echo "Processing $f file..."
  flast="$(basename -- $f)"
  docker run -d --rm -u root --mount type=bind,source=/tmp/result,target=/tmp/result --mount type=bind,source=$pdf_path,target=/opt/$pdf_name --mount type=bind,source=$f,target=/opt/$flast pdf_cracker:latest /bin/bash -c "--pdf /opt/$pdf_name --wordlist /opt/$flast --output /tmp/result/pass_crack_result.txt"
done
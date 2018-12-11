prompt = '\nEnter name of dir to create> ';
dirName = input(prompt);
    
if ~exist(dirName, 'dir')
    mkdir . dirName
end
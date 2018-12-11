pwd
prompt = '\nEnter name of dir to create> ';
dir2 = input(prompt, 's');
 
dir1 = '..\..\Data\Made by Sureyya\';
s = strcat(dir1,dir2)
s = strcat(s, '\')
if ~exist(s, 'dir')
    mkdir s
    
    % Make the subdirs
    s1 = strcat(s, '1 pH7')
    s2 = strcat(s, '2 pH4')
    s3 = strcat(s, '3 pH10')
    s4 = strcat(s, '4 pH7')
    s5 = strcat(s, '5 pH10')
    s6 = strcat(s, '6 pH4')
    s7 = strcat(s, '7 pH10')
    s8 = strcat(s, '8 pH7')
    s9 = strcat(s, '9 pH4')
    
    mkdir(s1)
    mkdir(s2)
    mkdir(s3)
    mkdir(s4)
    mkdir(s5)
    mkdir(s6)
    mkdir(s7)
    mkdir(s8)
    mkdir(s9)
else
    print('directory: %s exists', s);
end



global subdirs;
subdirs = ["1 pH7", "2 pH4", "3 pH10", "4 pH7", "5 pH10", "6 pH4", ...
    "7 pH10", "8 pH7", "9 pH4"];

returnCode = createDirAndSubDirs();

if returnCode == 1
    fprintf('Success');
else if returnCode == -1
        fprintf('Failure');
    else
        fprintf('Unrecognized return code: %d\n', returnCode);
    end
end

function a = createDirAndSubDirs()
    global subdirs;
    pwd
    prompt = '\nEnter name of dir to create> ';
    dir2 = input(prompt, 's');
    dir1 = '..\..\Data\Made by Sureyya\'; % just use relative directory
                                          % skip use of pwd for now
    s = strcat(dir1,dir2);
    if ~exist(s, 'dir')
        [status, msg, msgID] = mkdir(s);
        if status == 1 % keep going
            s = strcat(s, '\');
            % Make the subdirs inside 's'
            s1 = strcat(s, subdirs(1));
            s2 = strcat(s, subdirs(2));
            s3 = strcat(s, subdirs(3));
            s4 = strcat(s, subdirs(4));
            s5 = strcat(s, subdirs(5));
            s6 = strcat(s, subdirs(6));
            s7 = strcat(s, subdirs(7));
            s8 = strcat(s, subdirs(8));
            s9 = strcat(s, subdirs(9));
            
            % mkdir(s1) works at the cmd line, but via script, error is:
            % Error using mkdir. Argument must contain a character vector.
            [status1, msg, msgID] = mkdir(char(s1));
            [status2, msg, msgID] = mkdir(char(s2));
            [status3, msg, msgID] = mkdir(char(s3));
            [status4, msg, msgID] = mkdir(char(s4));
            [status5, msg, msgID] = mkdir(char(s5));
            [status6, msg, msgID] = mkdir(char(s6));
            [status7, msg, msgID] = mkdir(char(s7));
            [status8, msg, msgID] = mkdir(char(s8));
            [status9, msg, msgID] = mkdir(char(s9));
            status = status1 + status2 + status3 + status4 + ...
                status5 + status6 + status7 + status8 + status9;
            if status == 9
                a = 1;
            else
                a = -1;
            end
        else
            fprintf('%s\n', msg);
            a = status;
        end
    else
        fprintf('directory: %s exists. Choose another name.', s);
        a = -1;
    end
end


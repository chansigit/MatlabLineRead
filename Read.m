clear
clc
filename='RateCoefficient.dat';
fid = fopen(filename);
if (fid==-1)
    disp(sprintf('cannot open file `%s`', filename))
    return
end

tline = fgets(fid);
datasetID=0;
col1=[];
col2=[];
csv_matrix=[];

while ischar(tline)
    if (length(tline)<4) % ignore the blank line
        tline = fgets(fid);
        continue; 
    end
    
    if tline(1)=='C' % This is a begining line
        % datasetID increase
        datasetID= datasetID+1;
        % write previous record into csv (if any)
        if length(col2)>0
            csv_matrix(: , datasetID)=[datasetID-1, col2];
            csv_matrix(: , 1)=[NaN,col1];
        end
        % clear accumulated records
        col1=[];
        col2=[];
    end
    
    if tline(1)=='N' % Handle the last dataset
        % datasetID increase
        datasetID= datasetID+1;
        % write previous record into csv (if any)
        if length(col2)>0
            csv_matrix(: , datasetID)=[datasetID-1, col2];
            csv_matrix(: , 1)=[NaN,col1];
        end
        % clear accumulated records
        col1=[];
        col2=[];
    end
    
    C = textscan(tline,'%f');
    if length(C{1})~=2 % ignore the header line
        tline = fgets(fid);
        continue;
    end
    
    col1 = [col1, C{1}(1)];
    col2 = [col2, C{1}(2)];
    
    % read next line
    tline = fgets(fid);
    
end


csvwrite('RateCoefficient.csv', csv_matrix)

function []=PrinteIDOnce(file,index)

[INTABLE] = ReadTable(file,'\n');
[namefile dir]=IsolateFileName({file});
outfile=[dir{1},namefile{1},'_printonce.txt'];
INTABLE_noheader=INTABLE(index(1)+1:end,:);

[TABLE Address]=Douplicates(file,index(1:2));
FileWriteTable(outfile,INTABLE(index(1),:),[],'w');
logical_index=zeros(size(INTABLE,2),1);
logical_index(index(2:end))=1;
for i=unique(Address)'
    cur_INTABLE=INTABLE_noheader(Address==i,:);
    
    cur_INTABLE(2:end,logical_index==1)={''};
    
    FileWriteTable(outfile,cur_INTABLE,[],'a');
    
end

end
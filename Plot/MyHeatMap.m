function [f1,FREQ,x_,y_]=MyHeatMap(TABLE,groups,ids,texts_,Names,Colors_2D)
f1=figure;
f2=figure;
temp=hot;
hot_inv=temp(end:-1:1,:);
max1=max(TABLE(:,1));
min1=min(TABLE(:,1));
% max1=1800;
% min1=400;
y_=(0:.05:1)*(max1-min1);y_=y_+min1;
y_ctrs=mean([y_(2:end);y_(1:end-1)]);
x_=(-1:(2/(length(y_)-1)):1)*3;x_ctrs=mean([x_(2:end);x_(1:end-1)]);
FREQ=zeros(size(x_,2),size(x_,2),length(unique(groups)));
count=0; %% are proteins with peptides out of the detectable area
% OUT_OF_DETECTABLE_AREA=[];
subpl=length(unique(groups));

Colors=RainbowColor(1,'y2m');
Colors=[1 1 1;Colors(2:end,:)]

for i=unique(groups)'
    dat = TABLE(groups==i,:);
    names=Names(groups==i,:);
    n=zeros(length(x_),length(y_));
    Total_Tryptic=size(dat,1);
      
    for j=unique(ids(groups==i))' %% for each protein
        sub_data=dat(ids(groups==i)==j,:); %% choose peptides of protein j
        [n_ x]= hist3(sub_data,'Ctrs',{y_;x_}); % 2D hist data;
        if(sum(sum(n_))>0)
            n=n_+n; %% Add probability of a peptide being in a specific area
        end
        if(i==1)
            index=find(ids(groups==i)==j);
            DetArea=FREQ(:,:,1)>0;
            TheoretArea=n_>0;
            if(sum(DetArea==1 & TheoretArea==1)==0)
                count=count+1;
%                 OUT_OF_DETECTABLE_AREA=[OUT_OF_DETECTABLE_AREA;names(index(1),:)];
            end
        end
    end
    n=(n./size(dat,1))*100;
    FREQ(:,:,i+1)=n;    
        
    figure(f1);
%     subplot(subpl,1,i+1);
    hold on;
    view(3);
    box off;
    xlabel('m/z');
    ylabel('GRAVY');
    colormap(Colors);

    if(exist('Colors_2D','var')==0)
        cur_2d_color=hot_inv(end-(i*20),:);
    else
        cur_2d_color=Colors_2D(i+1,:);
    end

    [freq]=hist(dat(:,1),y_);freq=freq*100./Total_Tryptic;
    plot3(y_,ones(length(y_))*x_(end),freq,'Color',cur_2d_color);
    z_axis=(0:.05:1)*max(freq);
    x_axis=ones(length(z_axis),1)*mean(dat(:,1));
    plot3(x_axis,ones(length(x_axis))*x_(end),z_axis,'Color',cur_2d_color,'LineStyle',':');

    [freq]=hist(dat(:,2),x_);freq=freq*100./Total_Tryptic;
    plot3(ones(length(x_))*y_(end),x_,freq,'Color',cur_2d_color);
    z_axis=(0:.05:1)*max(freq);
    y_axis=ones(length(z_axis),1)*mean(dat(:,2));
    plot3(ones(length(x_))*y_(end),y_axis,z_axis,'Color',cur_2d_color,'LineStyle',':');
    
    text(max(y_),max(x_),10+(i*5),texts_{i+1},'Color',cur_2d_color,'HorizontalAlignment','Center');
    
    h=pcolor(x{1,1},x{1,2},n');shading flat;
    set(h, 'zdata', ones(size(n)) *(i)*40);
    text(1,3,((i)*40)+1,[texts_{i+1}],'Color','k','FontWeight','bold','Rotation',45);
%     title(texts_{i+1});
    hold off;
    colorbar;
    
    figure(f2);subplot(2,1,i+1);
    colormap(Colors);
    pcolor(x{1,1},x{1,2},n');shading flat;
    colorbar;
    xlabel('m/z');ylabel('GRAVY');
    hold off;
    
end
display(['Found proteins with no peptides in the detectable area: ',num2str(count)]);
end

function [X2D]=MultipleCopiesVector(X,copies)
X2D=zeros(copies,length(X));
while (copies>0)
    X2D(copies,:)=X;
    copies=copies-1;
end

end
% 蓝色渐变线条3D爱心动画
clear; clc; close all;

% 1. 定义爱心隐函数
f = @(x,y,z)(x.^2 + 2.25*y.^2 + z.^2 -1).^3 - x.^2.*z.^3 - 0.1125*y.^2.*z.^3;

% 2. 生成3D网格
[x,y,z] = meshgrid(linspace(-1.5,1.5,50));

% 3. 计算爱心表面
[faces,verts] = isosurface(x,y,z,f(x,y,z),0);

% 4. 创建图形窗口
figure('Color','black');
axis equal off;  % 隐藏坐标轴
view(3);         % 3D视角
grid off;        % 隐藏网格

% 5. 创建蓝色渐变颜色映射
n = size(verts,1);
colors = [linspace(0.2,0.8,n)' linspace(0.4,1,n)' ones(n,1)]; % 从深蓝到浅蓝

% 6. 绘制渐变线条爱心
h = patch('Faces',faces,'Vertices',verts,...
         'FaceColor','none','EdgeColor','flat',...
         'EdgeAlpha',0.8,'LineWidth',1.5,...
         'FaceVertexCData',colors);

% 7. 添加动态标题
titleHandle = text(0,0,1.8,'I Love You!',...
                 'FontSize',24,'Color','white',...
                 'HorizontalAlignment','center');

% 8. 动画循环 (按Ctrl+C停止)
scale = 1;
while true
    scale = scale * 0.99;  % 每次缩小1%
    if scale < 0.85        % 缩到85%后恢复
        scale = 1;
        
        set(titleHandle,'Color',[1 1 1]); 
        pause(0.1);
        set(titleHandle,'Color',[0.5 0.5 1]); 
        pause(0.1);
    end
    set(h,'Vertices',verts*scale);  % 缩放爱心
    drawnow;               % 立即更新图形
    pause(0.03);           % 暂停0.03秒
end
# Chapter 2：环境工程数据可视化

## 2.1 基本绘图技巧

### 2.1.1 二维图形绘制基础

plot函数是MATLAB中最基础的绘图工具，特别适合环境数据的时间序列展示：

```matlab
% 地球城市温度数据可视化案例
months = 1:12;
beijing_temp = [-3.2, 0.7, 7.6, 15.2, 21.8, 26.1, 27.9, 26.4, 21.5, 14.8, 6.3, -1.1];
shanghai_temp = [4.2, 5.8, 9.7, 15.6, 20.9, 25.3, 29.1, 28.6, 24.8, 19.5, 13.1, 6.8];

figure('Color','w','Position',[100 100 800 400])
plot(months, beijing_temp, 'r-o', 'LineWidth', 1.5, 'MarkerSize', 8,...
     'DisplayName','北京')
hold on
plot(months, shanghai_temp, 'b--s', 'LineWidth', 1.5, 'MarkerSize', 8,...
     'DisplayName','上海')
hold off

% 图表美化
xlabel('月份', 'FontSize',12, 'FontName','Microsoft YaHei')
ylabel('温度(℃)', 'FontSize',12)
title('2023年城市月均温度对比', 'FontSize',14, 'FontWeight','bold')
legend('Location','northwest', 'FontSize',10)
grid on
set(gca, 'XTick',1:12, 'XTickLabel',{'1月','2月','3月','4月','5月','6月',...
                    '7月','8月','9月','10月','11月','12月'})
```

**关键参数说明**：
- `'r-o'`：红色实线带圆形标记
- `'b--s'`：蓝色虚线带方形标记
- `FontName`属性支持中文字体显示
- `Position`参数控制图形窗口大小和位置

### 2.1.2 多图组合与子图布局

subplot函数可以创建多图组合，适合对比分析不同环境指标：

```matlab
% 火星基地环境参数监测
sol = linspace(0, 24, 100);  % 火星日
temperature = -50 + 30*sin(2*pi*sol/24);
pressure = 600 + 50*cos(2*pi*sol/12);
oxygen = 0.15 + 0.02*randn(size(sol));

figure('Color','w', 'Position',[100 100 900 600])

% 温度子图
subplot(3,1,1)
plot(sol, temperature, 'Color',[0.8 0.2 0.2], 'LineWidth',2)
title('火星基地温度变化', 'FontSize',12)
ylabel('温度(℃)')
grid on

% 气压子图
subplot(3,1,2)
plot(sol, pressure, 'Color',[0.2 0.6 0.3], 'LineWidth',2)
title('气压变化', 'FontSize',12)
ylabel('气压(Pa)')
grid on

% 氧气浓度子图
subplot(3,1,3)
plot(sol, oxygen, 'Color',[0.1 0.3 0.8], 'LineWidth',2)
title('氧气浓度波动', 'FontSize',12)
xlabel('火星时 (MLT)')
ylabel('O₂浓度(%)')
grid on
```

**专业技巧**：
1. 使用`tiledlayout`替代`subplot`可获得更灵活的布局
2. `linkaxes`函数可同步多个子图的坐标轴缩放
3. 颜色使用RGB三元组实现精确控制

### 2.1.3 交互式图形工具

MATLAB提供了强大的交互式绘图功能：

```matlab
% 创建交互式散点图
earth_data = readtable('earth_pollution.csv');
mars_data = readtable('mars_atmosphere.csv');

figure
gscatter(earth_data.PM25, earth_data.NO2, earth_data.City,...
         [], 'o', 8, 'on', 'PM2.5', 'NO₂')
title('地球城市污染物浓度分布 (鼠标悬停查看数据)')
xlabel('PM2.5(μg/m³)')
ylabel('NO₂(ppb)')
grid on

% 启用数据光标模式
datacursormode on
dcm = datacursormode(gcf);
set(dcm, 'UpdateFcn', @myCursorCallback)

function output_txt = myCursorCallback(~, event_obj)
    pos = get(event_obj,'Position');
    output_txt = {
        ['PM2.5: ', num2str(pos(1),'%.1f μg/m³')],...
        ['NO₂: ', num2str(pos(2),'%.1f ppb')]
    };
end
```

## 2.2 环境数据专题可视化

### 2.2.1 地理空间数据可视化

Mapping Toolbox提供了专业的地理可视化功能：

```matlab
% 中国PM2.5空间分布
if license('test','MAP_Toolbox')
    load china_boundary.mat
    pm25_data = ncread('china_pm25.nc','PM25');
    lat = ncread('china_pm25.nc','lat');
    lon = ncread('china_pm25.nc','lon');
    
    figure('Color','w')
    axesm('mercator','MapLatLimit',[15 55],'MapLonLimit',[70 140])
    geoshow(china_boundary, 'FaceColor',[0.9 0.9 0.8])
    contourfm(lat, lon, pm25_data, 0:10:200,...
              'LineStyle','none')
    colorbar('southoutside')
    title('中国PM2.5年均浓度分布(μg/m³)')
    colormap(jet)
else
    warning('未安装Mapping Toolbox，无法执行地理绘图');
end
```

**火星基地地图示例**：

```matlab
% 火星乌托邦平原基地地图
[Z, refvec] = dteds('martian_dem.dt1',1);
latlim = [40 50];
lonlim = [-120 -110];

figure
worldmap(latlim, lonlim)
geoshow(Z, refvec, 'DisplayType','texturemap')
demcmap(Z)
title('火星基地选址地形图')
textm(45, -115, '候选基地位置',...
      'Color','w', 'FontWeight','bold')
```

### 2.2.2 三维与动态可视化

**污染物扩散三维模拟**：

```matlab
% 工厂烟囱污染物扩散模拟
[x,y] = meshgrid(-100:10:100);
z = peaks(size(x,1));
conc = 1000*exp(-(x.^2 + y.^2)/2000).*z;

figure('Color','w')
surf(x,y,z,conc, 'EdgeColor','none')
title('污染物浓度三维分布')
xlabel('东向距离(m)')
ylabel('北向距离(m)')
zlabel('高度(m)')
colorbar('Title','浓度(μg/m³)')
view(40,30)
```

**动态可视化示例**：

```matlab
% 创建污染物扩散动画
figure('Color','w')
for t = 1:0.5:10
    conc = 1000*exp(-(x.^2 + y.^2)/(200*t)).*z;
    surf(x,y,z,conc, 'EdgeColor','none')
    title(['污染物扩散模拟 t = ',num2str(t),'小时'])
    zlim([-5 5])
    caxis([0 1000])
    view(40,30)
    drawnow
    frame = getframe(gcf);
    im{t} = frame2im(frame);
end

% 保存为GIF
filename = 'pollution_spread.gif';
for idx = 1:length(im)
    [A,map] = rgb2ind(im{idx},256);
    if idx == 1
        imwrite(A,map,filename,'gif','LoopCount',Inf,'DelayTime',0.2);
    else
        imwrite(A,map,filename,'gif','WriteMode','append','DelayTime',0.2);
    end
end
```

### 2.2.3 专业环境图表

**箱线图分析环境数据分布**：

```matlab
% 五大湖水质参数对比
lake_data = readtable('great_lakes_quality.csv');

figure('Color','w')
boxchart(lake_data.Lake, lake_data.PH,...
         'BoxWidth',0.6, 'MarkerStyle','+')
title('五大湖pH值分布比较')
ylabel('pH值')
grid on
```

**极坐标图展示风向频率**：

```matlab
% 火星基地风向玫瑰图
wind_directions = 0:22.5:360;
wind_freq = [5 8 12 15 10 7 5 3 2 4 6 9 11 14 10 6];

figure('Color','w')
polarhistogram('BinEdges',deg2rad([wind_directions 360]),...
               'BinCounts',wind_freq,...
               'FaceColor',[0.2 0.6 0.8],...
               'EdgeColor','w')
title('火星基地风向频率分布')
```

## 2.3 竞赛风格可视化技巧

### 2.3.1 决策支持图表

**平行坐标图比较多变量关系**：

```matlab
% 城市环境指标比较
cities = {'北京','上海','广州','成都','兰州'};
air_quality = [65, 42, 38, 58, 72];
water_quality = [7.2, 7.8, 8.1, 7.5, 6.9];
green_ratio = [0.48, 0.42, 0.45, 0.39, 0.31];

figure('Color','w')
parallelplot(table(air_quality',water_quality',green_ratio',...
                'VariableNames',{'空气质量','水质','绿化率'},...
                'RowNames',cities),...
         'GroupVariable','RowNames',...
         'CoordinateTickStyle','auto')
title('城市环境指标平行坐标比较')
```

### 2.3.2 热力图与关联分析

```matlab
% 环境参数相关性分析
env_data = randn(100,5);  % 模拟5种环境参数
var_names = {'PM2.5','SO₂','NO₂','O₃','CO'};

corr_matrix = corrcoef(env_data);

figure('Color','w')
heatmap(var_names, var_names, corr_matrix,...
        'Colormap',parula,...
        'Title','污染物相关性矩阵')
```

## 2.4 可视化输出与报告整合

### 2.4.1 专业图形导出设置

```matlab
% 配置出版级图形输出
figure('Color','w','Units','inches','Position',[0 0 6 4])
plot(rand(1,10), title('示例图形')

% 导出设置
exportgraphics(gcf,'figure.png',...
               'Resolution',600,...
               'BackgroundColor','white',...
               'ContentType','auto')
```

### 2.4.2 Live Script交互式报告

```matlab
%% 火星基地环境报告
% *任务*：分析第1-100火星日的环境数据

% 数据导入
env_data = readtable('mars_base_data.xlsx');

%% 温度分析
% 日均温度变化趋势：
plot(env_data.Sol, env_data.Temperature)
xlabel('火星日')
ylabel('温度(℃)')

%% 氧气生产评估
% 当前系统效率：
eff = mean(env_data.O2_Production ./ env_data.Energy_Used);
disp(['当前氧能转换效率：', num2str(eff*100, '%.1f'), '%'])
```

**本章小结**：
1. 从基础plot到三维动态可视化的完整技能栈
2. 地球与火星双案例实践，掌握环境工程特色图表
3. 竞赛级可视化技巧提升作品专业度
4. 输出设置确保研究成果完美呈现

**开拓者任务**：
- 地球版：创建你所在城市3年空气质量动态热力图
- 火星版：设计火星基地环境监测仪表盘（至少含3种参数）
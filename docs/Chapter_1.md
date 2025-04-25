# Chapter 1 MATLAB基础：环境工程计算入门

## 1.1 开始使用MATLAB

### 1.1.1 开发环境配置

MATLAB R2024a的界面包括多个核心组件，方便用户进行各种工程计算和数据可视化。以下是MATLAB开发环境的主要部分：

1. **命令窗口(Command Window)**：这是MATLAB的交互式执行窗口，您可以在这里输入代码并即时查看计算结果，适用于快速调试和验证。
2. **工作区(Workspace)**：显示当前会话中所有变量的值和类型，这有助于用户跟踪和管理数据。
3. **编辑器(Editor)**：MATLAB的代码编辑器具有智能提示、语法高亮和自动缩进等功能，非常适合编写和调试较复杂的代码。
4. **应用程序(App Designer)**：用于开发图形用户界面（GUI），方便用户创建交互式应用程序。本章第五节将详细介绍。

为了进行环境工程相关的计算，我们还需要安装一些额外的工具箱：

- **Mapping Toolbox**：用于地理空间数据分析，非常适合处理环境监测数据。
- **Curve Fitting Toolbox**：用于模型拟合，能够通过不同的算法找到数据中的最佳拟合曲线。
- **Partial Differential Equation Toolbox (PDE求解)**：解决与环境工程相关的偏微分方程，适用于模拟大气污染扩散等问题。

### 1.1.2 基础操作规范

在MATLAB中，以下是一些基础的操作规范和技巧：

- **帮助文档调用**：通过`doc`命令可以查看函数的详细文档。例如：

  ```matlab
  doc plot        % 查看官方文档
  lookfor fourier % 使用关键词搜索相关函数
  ```

- **代码注释标准**：代码注释是良好编程习惯的一部分，可以提高代码可读性。

  ```matlab
  % 单行注释
  %% 分节注释（可在编辑器中使用Ctrl+Enter运行本节）
  ```

### 1.1.3 温度曲线绘制案例

以下是基于中国气象局2023年实测数据的温度曲线绘制案例：

```matlab
% 北京月平均温度(℃)
months = linspace(1,12,12);
temp = [-3.2, 0.7, 7.6, 15.2, 21.8, 26.1, 
        27.9, 26.4, 21.5, 14.8, 6.3, -1.1];

figure('Name','城市温度分析','Color','white')
plot(months, temp, 'LineWidth', 1.5, 'Color', [0.2 0.4 0.8])
xlabel('月份', 'FontSize', 11, 'FontName', 'Microsoft YaHei')
ylabel('温度(℃)', 'FontSize', 11)
title('北京市2023年月平均温度变化','FontWeight','bold')
set(gca, 'GridLineStyle', '--')  % 设置网格线样式
```

此外，我们还可以模拟火星的温度变化，以模拟环境监测数据的处理：

```matlab
% 火星乌托邦平原日照时段温度模拟
sol = 0:0.5:24;  % 火星时(Mars Local Time)
T_surface = -50 + 30*sin(2*pi*sol/24);  % 简化的热力学模型

figure('Position', [100 100 600 300])  % 设置图形位置和大小
plot(sol, T_surface, 'r-', 'DisplayName', '地表温度')
xlim([0 24])
xticks(0:4:24)
xlabel('火星时 (MLT)')
ylabel('温度(℃)')
legend('Location', 'northeast')
text(8, -20, {'数据来源：', 'Mars Climate Database v5.3'},...
     'EdgeColor', 'k')
```

------

要将**变量命名、数据类型、元胞数组和结构体、矩阵构造与四则运算、矩阵下标、程序结构、二维与三维平面绘图**等内容融入到第一章的内容中，您可以按照以下方式进行扩展和组织：

### 1.2 基础语法与矩阵操作（扩展版）

#### 1.2.1 变量命名与数据类型

MATLAB的变量命名规则相对宽松，但为了提高代码的可读性和规范性，建议遵循一些最佳实践：

- 变量名必须以字母开头，后跟字母、数字或下划线（`_`）。
- 变量名应该具有描述性，避免使用单个字母（除非是常见的数学符号，如`i`表示虚数单位）。

MATLAB支持的常见数据类型包括：

- **数值类型**：如`double`（默认数值类型），`single`，`int8`等。
- **字符型与字符串**：如`char`（字符数组）和`string`（字符串数组）。
- **逻辑型**：如`true`和`false`。
- **元胞数组（cell arrays）**：存储不同类型数据。
- **结构体（structs）**：用于存储具有不同字段的关联数据。

**示例**：

```matlab
% 变量命名和数据类型示例
radius = 5;  % 数值型变量
location = [40.7128, -74.0060];  % 存储经纬度的数组
name = "MATLAB环境工程计算";  % 字符串变量
is_active = true;  % 逻辑类型
```

#### 1.2.2 元胞数组和结构体

- **元胞数组**：可以存储不同数据类型的元素。常用于存储混合数据。

  ```matlab
  C = {1, 'text', [1, 2, 3]};
  disp(C{2});  % 访问元胞数组中的元素
  ```

- **结构体**：可以将多个数据字段组织在一起，适合存储与某一对象相关的信息，如存储一个气象站的数据。

  ```matlab
  station.name = '北京';
  station.temperature = [1.1, 2.2, 3.3];  % 温度数组
  station.location = [39.9042, 116.4074];  % 经纬度
  ```

#### 1.2.3 矩阵构造与四则运算

MATLAB的核心是矩阵，以下是一些常用的矩阵操作：

- **矩阵构造**：可以通过方括号`[]`创建矩阵。

  ```matlab
  A = [1, 2; 3, 4];  % 2x2矩阵
  B = [5; 6];  % 2x1列向量
  ```

- **四则运算**：矩阵的加法、减法、乘法和除法。

  ```matlab
  C = A + B;  % 矩阵加法
  D = A * B;  % 矩阵乘法
  E = A / 2;  % 每个元素除以2
  ```

- **矩阵的转置**：

  ```matlab
  F = A';  % 矩阵转置
  ```

- **矩阵与标量的四则运算**：支持矩阵与标量的直接运算。

  ```matlab
  G = A + 3;  % 每个元素加3
  ```

#### 1.2.4 矩阵下标与访问

- **下标访问**：MATLAB采用1基索引访问矩阵中的元素。

  ```matlab
  element = A(1, 2);  % 访问第1行第2列的元素
  ```

- **切片操作**：可以通过冒号（`:`）进行行列的选择。

  ```matlab
  row = A(1, :);  % 获取第1行
  col = A(:, 2);  % 获取第2列
  ```

- **逻辑索引**：通过逻辑条件筛选矩阵元素。

  ```matlab
  filtered_data = A(A > 2);  % 获取大于2的元素
  ```

#### 1.2.5 程序结构

MATLAB支持标准的控制结构，如条件语句、循环等，用于实现复杂的程序逻辑。

- **条件语句**：使用`if-else`结构来处理不同的条件。

  ```matlab
  if temperature > 30
      disp('炎热');
  else
      disp('温暖');
  end
  ```

- **循环**：通过`for`和`while`实现循环。

  ```matlab
  % 使用for循环遍历数组
  for i = 1:length(temperature)
      disp(temperature(i));
  end
  ```

#### 1.2.6 绘图：二维与三维平面

MATLAB强大的绘图功能使其成为环境数据可视化的理想工具。

- **二维绘图**：可以使用`plot`函数进行简单的二维线性绘图。

  ```matlab
  x = linspace(0, 10, 100);
  y = sin(x);
  plot(x, y);  % 绘制正弦曲线
  title('正弦波');
  xlabel('x轴');
  ylabel('y轴');
  ```

- **三维绘图**：`meshgrid`和`surf`等函数可以绘制三维图形，适合展示复杂的数据集。

  ```matlab
  [X, Y] = meshgrid(-5:0.25:5, -5:0.25:5);
  Z = X.^2 + Y.^2;  % 创建一个抛物面
  surf(X, Y, Z);  % 绘制三维曲面图
  title('三维抛物面');
  ```

------

### 1.3 环境数据导入与预处理

此部分内容与前面提到的基础数据类型和矩阵操作结合，在数据导入时利用矩阵运算和逻辑操作进行数据清洗和预处理：

```matlab
% 导入数据并进行简单处理
data = readtable('environment_data.csv');
clean_data = data(data.Temperature > -50, :);  % 清理不合格的温度数据
```

### 1.3.1 多源数据导入方法

MATLAB提供了多种方法导入不同格式的环境数据。常见的数据类型和推荐函数如下：

| 数据类型 | 推荐函数    | 环境工程应用场景 |
| -------- | ----------- | ---------------- |
| Excel    | `readtable` | 监测站小时级数据 |
| NetCDF   | `ncread`    | 气候模型输出     |
| HDF5     | `h5read`    | 卫星遥感数据     |

例如，使用`ncread`导入NASA的MERRA-2气溶胶数据：

```matlab
% 导入MERRA-2气溶胶数据（需先下载.nc文件）
ncfile = 'MERRA2_400.tavg1_2d_aer_Nx.20200101.nc4';
PM25 = ncread(ncfile, 'PM25');  % 读取PM2.5变量
lat = ncread(ncfile, 'lat');    % 纬度坐标
lon = ncread(ncfile, 'lon');    % 经度坐标
```

### 1.3.2 数据质量控制

在处理环境数据时，常常需要进行数据质量控制，如异常值检测。以下是一个基于Grubbs检验的异常值检测示例：

```matlab
% 使用Grubbs检验检测异常值
function [clean_data, outliers] = grubbs_test(data, alpha)
    G = abs(data - mean(data)) / std(data);
    critical_value = tinv(1-alpha/(2*length(data)), length(data)-2);
    threshold = (length(data)-1)/sqrt(length(data)) * ...
                sqrt(critical_value^2/(length(data)-2+critical_value^2));
    outliers = find(G > threshold);
    clean_data = data; 
    clean_data(outliers) = NaN;
end
```


\begin{wolframGraphics}[width=.75\linewidth]{example_2.wls}
(* 1. 定义一个产生箭头的命令 *)
arrow[start_, end_, type_] := 
Graphics3D[
    {type, 
        { Arrowheads[.02], Arrow[Tube[{start, end}, 0.06]] }
    },
Boxed->False];

(* 2. 创建三个坐标轴的箭头, 使用颜色进行区分 *)
xaxis = arrow[{-10, 0, 0}, {10, 0, 0}, Blue];
yaxis = arrow[{0, -10, 0}, {0, 10, 0}, Green];
zaxis = arrow[{0, 0, -10}, {0, 0, 10}, Red];

(* 3. 展示在同意坐标轴 *)
axis = {xaxis, yaxis, zaxis};

(* 4. 绘制一个函数由于测试 *)
fp4 = Plot3D[0.4*x + 0.2*Sin[y] + 0.2*x*y, {x, -5, 7}, {y, -6, 4}, ColorFunction->"Rainbow"];

(* 5. 显示三维函数图像和坐标轴 *)
figure = Show[axis, fp4]
Export["./ztikz_output/mma_data/example_2.wls.pdf", figure];
\end{wolframGraphics}
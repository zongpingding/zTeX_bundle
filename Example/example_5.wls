\begin{wolframGraphics}[width=.75\linewidth]{example_5.wls}
g=RandomGraph[{20,100}];
h=FindHamiltonianCycle[g];
figure = Legended[HighlightGraph[g,Style[h,Directive[Thick,Red]]],LineLegend[{Directive[Thick,Red]},{"Hamiltonian cycle"}]];
Export["./ztikz_output/mma_data/example_5.wls.pdf", figure];
\end{wolframGraphics}
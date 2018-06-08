clear all
clc
data = importdata('Vebic_data.xlsx');
NOx = zeros(13,14);
NOx(:,1) = data.OP1(:,11);
NOx(:,2) = data.OP2(:,11);
NOx(:,3) = data.OP3(:,11);
NOx(:,4) = data.OP4(:,11);
NOx(:,5) = data.OP5(:,11);
NOx(:,6) = data.OP6(:,11);
NOx(:,7) = data.OP7(:,11);
NOx(:,8) = data.OP8(:,11);
NOx(:,9) = data.OP9(:,11);
NOx(:,10) = data.OP10(:,11);
NOx(:,11) = data.OP11(:,11);
NOx(:,12) = data.OP12(:,11);
NOx(:,13) = data.OP13(:,11);
NOx(:,14) = data.OP14(:,11);

bsfc = zeros(13,14);
bsfc(:,1) = data.OP1(:,7);
bsfc(:,2) = data.OP2(:,7);
bsfc(:,3) = data.OP3(:,7);
bsfc(:,4) = data.OP4(:,7);
bsfc(:,5) = data.OP5(:,7);
bsfc(:,6) = data.OP6(:,7);
bsfc(:,7) = data.OP7(:,7);
bsfc(:,8) = data.OP8(:,7);
bsfc(:,9) = data.OP9(:,7);
bsfc(:,10) = data.OP10(:,7);
bsfc(:,11) = data.OP11(:,7);
bsfc(:,12) = data.OP12(:,7);
bsfc(:,13) = data.OP13(:,7);
bsfc(:,14) = data.OP14(:,7);

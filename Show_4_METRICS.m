function [IAM,CBA,microF1,macroF1,G,Pave]=Show_4_METRICS(y,Y,pre)
IAM=M_IAM(y,Y,pre);
[ microF1,macroF1,~] = M_F1(y,Y,pre);
[Pave,G,CBA]=Show_result(y,Y,pre);
end
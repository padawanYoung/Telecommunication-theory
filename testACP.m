%файл test.m
% =========================================================================
clc
close all
clear all
% =========================================================================
num_zach = 1405238;
num_zhurnal = 15;
% -------------------------------------------------------------------------
x_min = -5.4;
x_max = 5.4;
N0=0.85*10^(-7);
Nc0=12.5*10^(-7);
n_j=65;
% ------------------------------------------------------------------------- 
prnt = 0;                                      % <=0 - не cохраняет графики
% =========================================================================
acp = MyClass3(num_zach,num_zhurnal,x_min,x_max,N0,Nc0,n_j,prnt);
% =========================================================================
RandSign (acp);
RandFFT (acp);
mean (acp);
standard_deviation (acp);
% -------------------------------------------------------------------------
AnsSnoiseSyg (acp);
AnsSnoiseChan (acp);
AnsNum_variant (acp);
AnsL (acp);
AnsM_SIG (acp);
AnsStd_SIG (acp);
% -------------------------------------------------------------------------
GraphNoizeSignal (acp);
GraphNoizeSpectrum (acp)
% =========================================================================
RandSign(acp)
fftLowSig (acp);
AutoDetectPSW (acp);
SpeedTransf (acp)
WidthSpecSigTransf (acp)
InterferencePower (acp)
SnR (acp)
ThroughputChan (acp)
EfficientUtilization (acp)
CorrelationLowSig (acp);
FFT_CorrelationLowSig (acp);
% -------------------------------------------------------------------------
AnswMaxFriquency (acp)
AnsInterferencePower (acp)
AnsMediumPowSig (acp)
% -------------------------------------------------------------------------
GraphOutFltSignal (acp)
GraphOutFltSpectrum (acp)
GraphAutoDetectPSW (acp)
Graph_R_Signal (acp)
Graph_R_Spectrum (acp)
% =========================================================================
RandSign(acp);
QantizationStep (acp);
NumberQuantLevels (acp);
MeedlePowNoizeQuant (acp);
LevelSignQuant (acp);
Probability_J_Level (acp);
fftQantizationSYG (acp);
fftDigitalSYG (acp);
% -------------------------------------------------------------------------
AnsMIN (acp);
AnsMAX (acp);
AnsSnoiseChan (acp);
AnsDELTA (acp);
AnsMeedlePowNoizeQuant (acp)
AnsLevelSignQuant (acp)
AnsProbability_J_Level (acp)
% -------------------------------------------------------------------------
GraphDsSignal (acp);
GraphQuantSignal (acp);
GraphDsSpectrum (acp);
GraphQuantSpectrum (acp);
% -------------------------------------------------------------------------
AnsOverflowCode (acp)
AnsMediumPowSig (acp)
% -------------------------------------------------------------------------
Kotelnikov (acp)
% =========================================================================
% файл MyClass2.m
classdef MyClass2<MyClass
    properties (Access = protected)
        an;
        bn;
        Wn=2*pi*5000;
        ksi;
        spectrum2;
        spectrum3;
        Kx;
        tau;
        p;
        f_max;
        dt;
        Pr_s;
        T
        V_k
        Ch
        f_c
        dF_s
        P_c=0.5;%средняя мощность сигнала
        SNR
        K_eff
        P_n
        N0
        H=7;
        f_gr
    end
    
    methods
        function flt = MyClass2(num_zach,num_zhurnal,N0,prnt)
            flt = flt@MyClass(num_zach,num_zhurnal,prnt);
            if nargin>0
                flt.ksi = 0.4*(.010+0.1*flt.num_variant);
                flt.tau=((0:flt.N/8))*flt.Ts;
            end
            flt.an = [1 2*flt.ksi*flt.Wn flt.Wn^2];
            flt.bn = [flt.Wn*flt.Wn];
            flt.N0=N0;
        end
%--------------------------------------------------------------------------                
        function RandSign(flt)
            RandSign@MyClass(flt);
            [A,B,C,D]=tf2ss(flt.bn,flt.an);
            [bd,ad]=tfdata(c2d(ss(A,B,C,D),flt.Ts),'v');
            flt.SYG=5.0*filter(bd,ad,flt.random2); % Синал на выходе фильтра
        end
        function fftLowSig (flt)
            flt.spectrum2=(1/flt.N*fft(flt.SYG));
        end
        function AutoDetectPSW (flt)
            warning('off','all')
%             flt.p = findpeaks (findpeaks (findpeaks (abs(flt.spectrum2(1:flt.N/20)).^2)));
            flt.p = findpeaks(abs(flt.spectrum2(1:flt.N/20)).^2);
            flt.p = findpeaks(flt.p);
            flt.p = findpeaks(flt.p);
            p1 = 0.05 * max(flt.p);
            fr1 = 1:29.7:56*29.7;
            j=length(flt.p);
            for i = 1:length(flt.p)
                if flt.p(j) >= p1
                    flt.f_max = fr1(j*4)*10;
                    break;
                end
                j=j-1;
            end
            flt.dt=1/(2*flt.f_max);%шаг дисретизации
            fprintf('SamplingStep=%d\n',flt.dt);
            flt.Pr_s= flt.H/flt.dt; %производительность источника сообщений
            fprintf('PerfMessageSource=%d\n',flt.Pr_s);
            flt.T=flt.dt/8;% Длительность интервала времени на передачу каждого кодового символа
            fprintf('DurationTransf=%d\n',flt.T);
            flt.f_gr=1/(2*flt.dt);% Граничная частота ПП фильтра-восстановителя
            fprintf('Passband=%d\n',flt.T);
            warning('on','all')
        end
        function SpeedTransf (flt)
            flt.V_k=1/flt.T;% Скорость передачи кодовых символов
            flt.f_c=100*flt.V_k;
            fprintf('SpeedTransf=%d\n',flt.V_k);
        end
        function WidthSpecSigTransf (flt)
            F_b=3*flt.V_k;
            flt.dF_s=2*F_b;% Ширина спектра сигнала-переносчика
            fprintf('WidthSpecSigTransf=%d\n',flt.dF_s);
        end
        function InterferencePower (flt)
            flt.P_n=flt.dF_s*flt.N0;
        end
        function SnR (flt)
            flt.SNR=flt.P_c/flt.P_n;
            fprintf('SnR=%d\n',flt.SNR);
        end
        function ThroughputChan (flt)
            flt.Ch=flt.dF_s*log2(1+flt.SNR);% Пропускная способность канала
            fprintf('ThroughputChan=%d\n',flt.Ch);
        end
        function EfficientUtilization (flt)
            flt.K_eff=flt.Pr_s/flt.Ch;%Коэффициент эффективности использования канала 
        end
        function CorrelationLowSig (flt)
            flt.Kx=xcov(flt.SYG,'biased');
        end
        function FFT_CorrelationLowSig (flt)
            flt.spectrum3=(1/flt.N*fft(flt.Kx));
        end
%--------------------------------------------------------------------------        
        function AnswMaxFriquency (flt)
            fprintf('f_max=%f\n',flt.f_max);
        end
        function AnsInterferencePower (flt)
            fprintf('InterferencePower=%d\n',flt.P_n);
        end
        function AnsMediumPowSig (flt)
            fprintf('MediumPowSig=%d\n',flt.P_c);
        end 
%--------------------------------------------------------------------------        
        function GraphOutFltSignal (flt)
            warning('off','all')
            figure;
            plot(flt.t,flt.SYG,'k');
            title('Сигнал на выходе фильтра')
            xlabel('Время t, с')
            ylabel('Амплитуда Х, В')
            SetStandart (flt)
            if flt.Prnt>0
                print(gcf,'-dpng','-r128','GraphOutFltSignal.png');
            end
            warning('on','all')
        end
        function GraphOutFltSpectrum (flt)
            warning('off','all')
            figure;
            plot(flt.fr(1:flt.N/20),abs(flt.spectrum2(1:flt.N/20)).^2);
            title('Спектр сигнала на выходе фильтра');
            xlabel('Частота f, Гц')
            ylabel('Относительная амплитуда Х, В')
            SetStandart (flt)
            if flt.Prnt>0
                print(gcf,'-dpng','-r128','GraphOutFltSpectrum.png');
            end
            warning('on','all')
        end
        function GraphAutoDetectPSW (flt)
            warning('off','all')
            figure;
            plot(flt.fr(1:flt.N/20),abs(flt.spectrum2(1:flt.N/20)).^2,'Color',[.1 .7 .7]);
            hold on
            plot(flt.fr(1:29.7:numel(flt.p)*29.7),flt.p,'red','LineWidth',1.5)
            plot(flt.f_max,0:0.0001:max(flt.p), 'LineWidth',2)
            title('Практическая ширина спектра');
            xlabel('Частота f, Гц')
            ylabel('Относительная амплитуда Х, В')
            SetStandart (flt)
            if flt.Prnt>0
                print(gcf,'-dpng','-r128','GraphAutoDetectPSW.png');
            end
            warning('on','all')
        end
        function Graph_R_Signal (flt)
            warning('off','all')
            figure
            plot(flt.tau,flt.Kx(flt.N:flt.N+flt.N/8));
            title('График корреляционной функции');
            xlabel('Время t, с')
            ylabel('случайная величина X(t), B^2')
            SetStandart (flt)
            if flt.Prnt>0
                print(gcf,'-dpng','-r128','Graph_R_Signal.png');
            end
            warning('on','all')
        end
        function Graph_R_Spectrum (flt)
            warning('off','all')
            figure;
            plot(flt.fr(1:flt.N/20),abs(flt.spectrum3(1:flt.N/20)).^2);
            title('Спектр корреляционной функции');
            xlabel('Частота f, Гц')
            ylabel('Относительная амплитуда X, В^2/Гц')
            SetStandart (flt)
            if flt.Prnt>0
                print(gcf,'-dpng','-r128','Graph_R_Spectrum.png');
            end
            warning('on','all')
        end
    end
end


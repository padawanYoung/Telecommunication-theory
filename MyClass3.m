% файл MyClass3.m
classdef MyClass3 < MyClass2 
    properties (Access = protected)
        x_max;
        x_min;
        Dt;
        M=512.0;
        D_SYG;
        MAX;
        MIN;
        DELTA;
        D_SYG_Q;
        spectrum4;
        spectrum5;
        Lwl;
        P_sh;
        x_j;
        n_j;
        P_j;
        dx=3*2.6*10^(-2);
        Nc0
        overflow
        %- - - - - - - 
        y;
        y0;
        time;
%         as;
        swipe;
    end
    
    methods
        function acp = MyClass3(num_zach,num_zhurnal,x_max,x_min,N0,Nc0,n_j,prnt)
            acp = acp@MyClass2(num_zach,num_zhurnal,N0,prnt);
            acp.x_min=x_min;
            acp.x_max=x_max;
            acp.Dt=65;
            acp.n_j=n_j;
            acp.Nc0=Nc0;
            acp.overflow=1-log2(128)/8*log2(2);
        end 
%--------------------------------------------------------------------------                
        function RandSign (acp)
            RandSign@MyClass2(acp);
            for i=1:(acp.N/acp.Dt)
                acp.D_SYG(i)=acp.SYG(acp.Dt*i);
            end
        end
        function QantizationStep (acp)
            acp.MAX=max(acp.D_SYG);
            acp.MIN=min(acp.D_SYG);
            acp.DELTA=((acp.MAX-acp.MIN)*1.0/acp.M);
            acp.D_SYG_Q=acp.DELTA*round(acp.D_SYG/acp.DELTA);
        end
        function NumberQuantLevels (acp)
            acp.Lwl=(acp.x_max-acp.x_min)/acp.dx;%число уровней квантования            
        end
        function MeedlePowNoizeQuant (acp)
            acp.P_sh=acp.dx^2/12;%сред. мощность шума квантования
        end
        function LevelSignQuant (acp)
            acp.x_j=acp.x_min+acp.n_j*acp.dx;%уровень сигнала квантования
        end
        function Probability_J_Level (acp)
            acp.P_j=acp.dx/(acp.x_max-acp.x_min);%вероятность j-го уровня
        end
        function fftQantizationSYG (acp)
            acp.spectrum4=fft(acp.D_SYG);
        end
        function fftDigitalSYG (acp)
            acp.spectrum5=fft(acp.D_SYG_Q);
        end
%--------------------------------------------------------------------------        
        function AnsMIN (acp)
            fprintf('MIN=%d\n',acp.MIN);
        end
        function AnsMAX (acp) 
            fprintf('MAX=%d\n',acp.MAX);
        end
        function AnsSnoiseChan (acp)
            fprintf('SnoiseChan=%d\n',acp.SnoiseChan);
        end    
        function AnsDELTA (acp)
            fprintf('DELTA=%d\n',acp.DELTA);
        end 
        function AnsMeedlePowNoizeQuant (acp)
            fprintf('MeedlePowNoizeQuant=%d\n',acp.P_sh);
        end
        function AnsLevelSignQuant (acp)
            fprintf('LevelSignQuant=%d\n',acp.x_j);
        end
        function AnsProbability_J_Level (acp)
            fprintf('Probability_J_Level=%d\n',acp.P_j);
        end
        function AnsOverflowCode (acp)
            fprintf('OverflowCode=%d\n',acp.overflow);
        end
%-------Kotelnikov---------------------------------------------------------
        function Kotelnikov (acp)
%             disp (acp.x_min)
            RandSign (acp)
            QantizationStep (acp)
            fftLowSig (acp)
            AutoDetectPSW (acp)
            acp.time = -0.6:acp.dt:0.6;
            acp.time = acp.MIN:acp.dt:acp.MAX;
            acp.y0 = zeros(size(acp.time));
            figure;
            for i = 1:numel(acp.D_SYG_Q)
                acp.y = acp.D_SYG_Q(i)*sinc(acp.Dt*(acp.time-acp.DELTA*i));
                plot(acp.time,acp.y);
                hold on
                acp.y0 = acp.y0 + acp.y;
            end
            plot(acp.time,acp.y0,'r','LineWidth',2)
            xlim([0 0.25])
            title ('Восстановленный Сигнал')
            xlabel('Время, с')
            ylabel('Сигнал, В')
            SetStandart (acp)
            if acp.Prnt>0
                print(gcf,'-dpng','-r128','RestoreSignal.png');
            end                  
        end
%--------------------------------------------------------------------------
        function GraphDsSignal (acp)
            warning('off','all')
            figure;
            plot(acp.D_SYG);
            title('График дискретизованного сигнала')
            xlabel('Время t, с')
            ylabel('Амплитуда Х, В')
            SetStandart (acp)
            if acp.Prnt>0
                print(gcf,'-dpng','-r128','GraphDsSignal.png');
            end             
            warning('on','all')
        end
        function GraphQuantSignal (acp)
            warning('off','all')
            figure;
            plot(acp.D_SYG_Q,'b:');
            title('График оцифрованного сигнала')  
            xlabel('Время t, с')
            ylabel('Амплитуда Х, В')
            SetStandart (acp)
            if acp.Prnt>0
                print(gcf,'-dpng','-r128','GraphDsSpectrum.png');
            end              
            warning('on','all')
        end   
        function GraphDsSpectrum (acp)
            warning('off','all')
            figure;
            plot(abs(acp.spectrum4),'r');
            title('Спектр дискретизованного сигнала');
            xlabel('частота f, Гц')
            ylabel('Амплитуда Х, В')
            SetStandart (acp)
            if acp.Prnt>0
                print(gcf,'-dpng','-r128','GraphQuantSignal.png');
            end               
            warning('on','all')
        end
        function GraphQuantSpectrum (acp)
            warning('off','all')
            figure;
            plot(abs(acp.spectrum5),'r');
            title('Спектр оцифрованного сигнала');
            xlabel('частота f, Гц')
            ylabel('Относительная амплитуда Х, В')
            SetStandart (acp)
            if acp.Prnt>0
                print(gcf,'-dpng','-r128','GraphQuantSpectrum.png');
            end                 
            warning('on','all')
        end         
    end
end


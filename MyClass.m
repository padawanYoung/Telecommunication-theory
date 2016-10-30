% файл MyClass.m
classdef MyClass  < handle  
    properties (Constant = true)
        Mu = 0;
        Sigma = 1;
    end
   properties (Access = protected)
        L
        num_variant
        random2
        a
        fr
        SYG
        m_SIG
        std_SIG
        Ts
        N
        num_zach
        num_zhurnal       
        SnoiseSyg
        SnoiseChan
        spectrum1
        x
        t
        %Cвойства для настроек графиков:
        Fnt 
        ylab
        xlab
        %Cвойство, для сохранения графиков
        prnt
        Prnt
   end
    
    methods
          function obj = MyClass(num_zach,num_zhurnal,prnt)
            if nargin>0
                obj.Ts = 0.000001;
                obj.N = 2^15;
                obj.x = ((num_zach - (round(num_zach/1000))*1000)+round(num_zach/1000))/100;
                obj.a = ((num_zach - (round(num_zach/1000))*1000)+round(num_zach/1000))/100+0.5;
                obj.SnoiseSyg = (num_zhurnal+5)/(100*num_zach*num_zhurnal);
                obj.SnoiseChan = (num_zhurnal)/(10*num_zach*(num_zhurnal+5));
                obj.num_variant = 10*abs(10*(abs(cos(obj.x))*1000-round(abs(cos(obj.x))*1000))+0.1);
                obj.L = 50+num_zhurnal+ round(obj.num_variant);
                obj.SYG(1:obj.N) = 0; 
            	obj.t = (0:obj.N-1)*obj.Ts;
                obj.fr = (0:obj.N-1)/obj.N*1/obj.Ts; 
                obj.Prnt = prnt;
%             else
%                 error('Wrong number of input arguments')
            end
          end
%--------------------------------------------------------------------------          
        function RandSign (obj)
            obj.random2 = unifrnd(-obj.a,obj.a,1,obj.N);
        end
        function RandFFT (obj)
            obj.spectrum1 = (1/obj.N*fft(obj.random2));
        end
        function mean (obj)
            obj.m_SIG=mean(obj.random2);
        end
        function standard_deviation (obj)
            obj.std_SIG=std(obj.random2);
        end
%--------------------------------------------------------------------------
        function AnsSnoiseSyg (obj)
            fprintf('SnoiseSyg=%d\n',obj.SnoiseSyg);
        end
        function AnsSnoiseChan (obj)
            fprintf('SnoiseChan=%d\n',obj.SnoiseChan);
        end
        function AnsNum_variant (obj)
            fprintf('num_variant=%f\n',obj.num_variant);
        end
        function AnsL (obj)
            fprintf('L=%f\n',obj.L);
        end
        function AnsM_SIG (obj)
            fprintf('m_SIG=%f\n',obj.m_SIG);
        end
        function AnsStd_SIG (obj)
            fprintf('std_SIG=%f\n',obj.std_SIG);
        end 
%--------------------------------------------------------------------------
        function SetStandart (obj)
            % Настройки для графика
            obj.Fnt = findobj(gcf,'type','axes');
            obj.ylab = get(obj.Fnt,'YTickLabel');
            obj.ylab(obj.ylab == '.') = ',';
            set(obj.Fnt,'YTickLabel', obj.ylab);
            obj.xlab = get(obj.Fnt,'XTickLabel');
            obj.xlab(obj.xlab == '.') = ',';
            set(obj.Fnt,'XTickLabel', obj.xlab);
            %Оформляем подписи осей по ГОСТу 
            txt = findall(gcf,'type','text');
            set(txt,'FontSize',14,'FontName','Times');
        end
%--------------------------------------------------------------------------
        function  GraphNoizeSignal (obj) 
            warning('off','all')
            figure;
            plot(obj.random2);
            title('Исходный сигнал');%Cигнал с равномерным распределением случайной величины
            xlabel('Время t, с')
            ylabel('Случайная величина X(t), В');
            SetStandart (obj)
            if obj.Prnt>0
                print(gcf,'-dpng','-r128','GraphNoizeSignal.png');
            end
            warning('on','all')
        end
        function GraphNoizeSpectrum (obj)
            warning('off','all')
            figure;
            plot(obj.fr(1:obj.N/20),abs(obj.spectrum1(1:obj.N/20)).^2);
            title('Спектр исходного сигнала');%Его спектр
            xlabel('частота f, Гц')
            ylabel('Относительная амплитуда Х, В')
            SetStandart (obj)
            if obj.Prnt>0
                print(gcf,'-dpng','-r128','GraphNoizeSpectrum.png');
            end
            warning ('on', 'all')
        end
    end 
end
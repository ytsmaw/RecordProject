

function result = RIAAprep(source, fs, makesounds)

% Reproduce the RIAA equilisation curve
% (http://www.beigebag.com/case_riaa_1.htm)

%fourier transform of the source
sourceF = fft(source(:,1));
fq = 1:ceil(length(sourceF)/2);
fq = fq*fs/ceil(length(sourceF)/2);
fq = [fq fliplr(fq)];

%apply the RIAA curve to the frequency spectrum
[attenrec,attenpla,dbplay,dbrec] = RIAA(fq);

%apply your curve to the recording
sourceEq = sourceF .* attenrec';

res = real(ifft(sourceEq));
res(abs(res)>1.2) = 1.2;
result = res;

if nargin == 3
    if makesounds == 1
        
        %output graphs just in case


        figure(1)
        subplot(1,2,1)
        semilogx(fq,dbplay,fq,dbrec)
        title('dB curve');
        legend('playback curve', 'recording curve')
        xlim([10,fs]);
        subplot(1,2,2)
        semilogx(fq,attenpla,fq,attenrec)
        title('voltage curve')
        legend('playback curve', 'recording curve')
        xlim([10,fs]);

        mx = max(result);
        
        figure(2)
        subplot(2,1,1)
        plot(result)
        title('Resulting waveform 1 (RIAA EQ`d)')
        sound(result(100000:541000),fs);
        ylim([-mx,mx])
        pause(10)

        subplot(2,1,2)
        plot(source(:,1))
        title('Original Waveform')
        sound(source(100000:541000),fs)
        ylim([-mx,mx])
        pause(10)

        sourceF2 = fft(result);
        sourceEq2 = sourceF2 .* attenpla';
        result2 = real(ifft(sourceEq2));

        figure(3)
        subplot(2,1,1)
        plot(result2)
        title('Resulting waveform 2 (original)')
        ylim([-1.5,1.5])
        soundsc(result2(100000:541000),fs);
        pause(10)

        subplot(2,1,2)
        plot(source(:,1))
        title('Original Waveform')
        ylim([-1.5,1.5])
        soundsc(source(100000:541000),fs)
    end
end
%}
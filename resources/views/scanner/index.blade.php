@extends('layouts.app')

@section('title', 'HUD Scanner | Scanner Core')
@section('header', 'System Ingress')

@section('content')
<div class="max-w-6xl mx-auto space-y-10 animate-in fade-in zoom-in duration-500">
    
    <!-- Meta Data Bar -->
    <div class="flex items-center justify-between px-6 py-3 bg-bg-card/30 backdrop-blur-md border border-border-subtle/50 rounded-xl font-mono text-[9px] tracking-[0.3em] text-text-dim shadow-xl relative overflow-hidden">
        <div class="absolute inset-0 opacity-[0.02]" style="background-image: linear-gradient(90deg, currentColor 1px, transparent 1px); background-size: 20px 100%;"></div>
        <div class="flex items-center space-x-8 relative z-10">
            <div class="flex items-center space-x-2">
                <span class="w-1.5 h-1.5 rounded-full bg-brand-primary animate-pulse shadow-[0_0_8px_rgba(36,210,171,1)]"></span>
                <span>Scanner Active</span>
            </div>
            <span>Status: <span class="text-brand-primary font-black uppercase">Connected</span></span>
        </div>
        <div class="flex items-center space-x-6 relative z-10">
             <span>Fast Connection</span>
              <span x-data="{ time: new Date().toLocaleTimeString() }" x-init="setInterval(() => time = new Date().toLocaleTimeString(), 1000)" x-text="'Time: ' + time"></span>
        </div>
    </div>

    <!-- Scanner Section -->
    <div class="grid grid-cols-1 lg:grid-cols-12 gap-6">
        
        <!-- Camera HUD (Left) -->
        <div class="lg:col-span-8 flex flex-col space-y-6">
            <div class="relative bento-card border-brand-primary/20 aspect-video bg-bg-main overflow-hidden group">
                <!-- html5-qrcode reader -->
                <div id="reader" class="w-full h-full scale-[1.02]"></div>

                <!-- HUD Overlays -->
                <div class="absolute inset-0 pointer-events-none">
                    <!-- Target Crosshair -->
                    <div class="absolute inset-0 flex items-center justify-center">
                        <div class="w-64 h-64 border border-brand-primary/20 relative rounded-3xl">
                            <!-- Corners (HUD Style) -->
                            <div class="absolute -top-2 -left-2 w-8 h-8 border-t-4 border-l-4 border-brand-primary rounded-tl-xl shadow-[0_0_15px_rgba(36,210,171,0.4)]"></div>
                            <div class="absolute -top-2 -right-2 w-8 h-8 border-t-4 border-r-4 border-brand-primary rounded-tr-xl shadow-[0_0_15px_rgba(36,210,171,0.4)]"></div>
                            <div class="absolute -bottom-2 -left-2 w-8 h-8 border-b-4 border-l-4 border-brand-primary rounded-bl-xl shadow-[0_0_15px_rgba(36,210,171,0.4)]"></div>
                            <div class="absolute -bottom-2 -right-2 w-8 h-8 border-b-4 border-r-4 border-brand-primary rounded-br-xl shadow-[0_0_15px_rgba(36,210,171,0.4)]"></div>
                            
                            <!-- Internal Guide -->
                            <div class="absolute inset-10 border border-brand-primary/10 bg-brand-primary/5 rounded-2xl animate-pulse"></div>
                            
                            <!-- Scanning Laser Line -->
                            <div class="absolute top-0 left-0 w-full h-0.5 bg-brand-primary shadow-[0_0_20px_rgba(36,210,171,1)] animate-[scan_2s_linear_infinite]"></div>
                             
                             <!-- CRT Scanline Noise -->
                             <div class="absolute inset-0 pointer-events-none opacity-20" style="background: linear-gradient(rgba(18, 16, 16, 0) 50%, rgba(0, 0, 0, 0.25) 50%), linear-gradient(90deg, rgba(255, 0, 0, 0.06), rgba(0, 255, 0, 0.02), rgba(0, 0, 255, 0.06)); background-size: 100% 2px, 3px 100%;"></div>
                        </div>
                    </div>

                    <!-- HUD Metadata -->
                    <div class="absolute top-4 left-4 font-mono text-[9px] text-brand-primary space-y-1">
                        <p>Position: Centered</p>
                        <p>Focus: Auto</p>
                        <p>Ready</p>
                    </div>
                    <div class="absolute bottom-4 right-4 font-mono text-[9px] text-brand-primary text-right">
                        <p>Stream: Active</p>
                        <p>Secure</p>
                    </div>
                </div>

                <!-- Status Flash Overlays -->
                <div id="success-flash" class="absolute inset-0 bg-brand-primary hidden items-center justify-center text-bg-main font-black text-4xl tracking-tighter italic transition-opacity z-20">VALID_AUTH</div>
                <div id="error-flash" class="absolute inset-0 bg-brand-danger hidden items-center justify-center text-white font-black text-4xl tracking-tighter italic transition-opacity z-20">AUTH_DENIED</div>
            </div>

            <!-- Controls -->
            <div class="flex items-center justify-center space-x-6">
                  <button id="start-btn" onclick="startScanner()" class="btn-primary space-x-3 px-12 py-4">
                    <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM9.555 7.168A1 1 0 008 8v4a1 1 0 001.555.832l3-2a1 1 0 000-1.664l-3-2z" clip-rule="evenodd" /></svg>
                    <span class="font-black uppercase tracking-widest italic">Start Scanning</span>
                  </button>
                  <button id="stop-btn" onclick="stopScanner()" class="btn-secondary hidden bg-brand-danger/20 border-brand-danger/30 text-brand-danger px-12 py-4 italic font-black uppercase tracking-widest">Stop Scanning</button>
            </div>
        </div>

        <!-- Feedback & Logs (Right) -->
        <div class="lg:col-span-4 flex flex-col space-y-6">
            
            <!-- Result Card -->
            <div x-data="{ state: 'idle', data: {} }" 
                 @scan-result.window="state = $event.detail.status; data = $event.detail.payload"
                 class="bento-card p-6 min-h-[220px] relative overflow-hidden flex flex-col items-center justify-center text-center">
                
                <div x-show="state === 'idle'" class="space-y-4">
                    <div class="w-12 h-12 bg-bg-elevated border border-border-subtle rounded-full flex items-center justify-center mx-auto">
                        <svg class="w-6 h-6 text-text-description animate-pulse" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                    </div>
                    <p class="text-xs font-bold text-text-description uppercase tracking-widest">Waiting for Scan</p>
                </div>

                <div x-show="state === 'success'" class="w-full space-y-6 animate-in fade-in zoom-in duration-300">
                      <div class="text-[10px] font-black text-brand-primary uppercase tracking-[0.3em] px-4 py-1.5 bg-brand-primary/10 border border-brand-primary/20 rounded-full inline-block italic">Ticket Valid</div>
                     <h3 class="text-2xl font-black text-text-bright tracking-tighter italic uppercase" x-text="data.name"></h3>
                      <div class="text-left bg-bg-elevated/50 p-6 rounded-2xl font-mono text-[10px] space-y-3 border border-border-subtle shadow-inner">
                          <p class="flex justify-between border-b border-border-subtle/30 pb-2"><span class="text-text-dim/60 font-black uppercase tracking-widest">Ticket ID</span> <span class="text-text-bright font-black" x-text="data.id"></span></p>
                          <p class="flex justify-between border-b border-border-subtle/30 pb-2"><span class="text-text-dim/60 font-black uppercase tracking-widest">Check-in Time</span> <span class="text-text-bright font-black" x-text="data.time"></span></p>
                          <p class="flex justify-between pt-1"><span class="text-text-dim/60 font-black uppercase tracking-widest">Event</span> <span class="text-brand-primary font-black">Main Event</span></p>
                      </div>
                </div>

                <div x-show="state === 'error'" class="w-full space-y-4 animate-in fade-in zoom-in duration-300">
                      <div class="text-xs font-bold text-brand-danger uppercase tracking-widest px-3 py-1 bg-brand-danger/10 rounded-full inline-block">Invalid Ticket</div>
                     <p class="text-text-dim text-sm" x-text="data.message"></p>
                </div>

            </div>

            <!-- Mini Terminal Log -->
            <div class="bento-card flex-1 min-h-[300px] p-0 font-mono text-[10px] bg-bg-main border-none shadow-2xl overflow-hidden">
                 <div class="px-6 py-3 border-b border-border-subtle/50 bg-bg-card/80 backdrop-blur-xl flex items-center justify-between">
                     <span class="technical-label text-text-bright opacity-100">Console.telemetry</span>
                     <div class="flex items-center space-x-1">
                        <span class="w-1 h-1 rounded-full bg-brand-primary shadow-[0_0_8px_rgba(36,210,171,1)]"></span>
                        <div class="w-1 h-1 rounded-full bg-brand-primary/20"></div>
                     </div>
                 </div>
                  <div id="terminal-body" class="p-6 space-y-3 overflow-y-auto h-[250px] scrollbar-thin scrollbar-thumb-brand-primary/20">
                       <p class="text-text-description/60 font-bold uppercase">> [08:00:01] Starting scanner...</p>
                       <p class="text-brand-primary font-black uppercase">> [08:00:02] Connected successfully.</p>
                       <p class="text-text-description/60 font-bold uppercase">> [08:00:03] Ready to scan.</p>
                  </div>
            </div>

        </div>

    </div>
</div>

<style>
@keyframes scan {
    0% { top: 0; }
    50% { top: 100%; }
    100% { top: 0; }
}
</style>

<!-- html5-qrcode library -->
<script src="https://unpkg.com/html5-qrcode" type="text/javascript"></script>
<script>
    let html5QrScanner;

    function addLog(msg, type = 'default') {
        const body = document.getElementById('terminal-body');
        const p = document.createElement('p');
        const timestamp = new Date().toLocaleTimeString();
        p.className = type === 'success' ? 'text-brand-success' : (type === 'error' ? 'text-brand-danger' : 'text-text-description');
        p.innerText = `> [${timestamp}] ${msg}`;
        body.appendChild(p);
        body.scrollTop = body.scrollHeight;
    }

    // Audio Context for Beeps
    const audioCtx = new (window.AudioContext || window.webkitAudioContext)();
    function beep(freq, duration) {
        const osc = audioCtx.createOscillator();
        const gain = audioCtx.createGain();
        osc.connect(gain);
        gain.connect(audioCtx.destination);
        osc.frequency.value = freq;
        osc.type = 'square';
        gain.gain.setValueAtTime(0.1, audioCtx.currentTime);
        osc.start();
        osc.stop(audioCtx.currentTime + (duration / 1000));
    }

    function onScanSuccess(decodedText, decodedResult) {
        if (html5QrScanner.isPaused) return;
        html5QrScanner.pause(); // Pause to prevent double scans
        
        addLog(`QR code detected: ${decodedText.substring(0, 15)}...`, 'info');
        
        const successFlash = document.getElementById('success-flash');
        const errorFlash = document.getElementById('error-flash');
        const auth = Alpine.store('auth');

        if (!auth.token) {
            addLog('Error: No admin token set in settings.', 'error');
            beep(200, 300);
            window.dispatchEvent(new CustomEvent('scan-result', { 
                detail: { status: 'error', payload: { message: 'Admin authentication required. Please set token in settings.' } } 
            }));
            setTimeout(() => html5QrScanner.resume(), 2000);
            return;
        }

        // Real API Call
        fetch('/api/ticket/checkin', {
            method: 'POST',
            headers: auth.headers,
            body: JSON.stringify({ code: decodedText })
        })
        .then(response => response.json())
        .then(result => {
            if (result.status === 'Success') {
                addLog('Ticket checked in successfully.', 'success');
                beep(800, 150);
                
                // UI Trigger
                successFlash.classList.remove('hidden');
                successFlash.classList.add('flex');
                setTimeout(() => {
                    successFlash.classList.add('hidden');
                    successFlash.classList.remove('flex');
                }, 600);

                window.dispatchEvent(new CustomEvent('scan-result', { 
                    detail: { 
                        status: 'success', 
                        payload: { 
                            name: result.data.user.name.toUpperCase(), 
                            id: result.data.id.substring(0,8).toUpperCase(), 
                            time: new Date(result.data.check_in_at).toLocaleTimeString() 
                        } 
                    } 
                }));
            } else {
                addLog(`Check-in failed: ${result.message}`, 'error');
                beep(200, 300);
                
                errorFlash.classList.remove('hidden');
                errorFlash.classList.add('flex');
                setTimeout(() => {
                    errorFlash.classList.add('hidden');
                    errorFlash.classList.remove('flex');
                }, 600);

                window.dispatchEvent(new CustomEvent('scan-result', { 
                    detail: { status: 'error', payload: { message: result.message } } 
                }));
            }
            // Resume after a delay
            setTimeout(() => html5QrScanner.resume(), 1500);
        })
        .catch(err => {
            addLog(`Error: ${err.message}`, 'error');
            beep(150, 400);
            setTimeout(() => html5QrScanner.resume(), 2000);
        });
    }

    function startScanner() {
        document.getElementById('start-btn').classList.add('hidden');
        document.getElementById('stop-btn').classList.remove('hidden');
        addLog('Camera started. Ready for scanning.', 'info');

        html5QrScanner = new Html5Qrcode("reader");
        html5QrScanner.start(
            { facingMode: "environment" },
            {
                fps: 15,
                qrbox: 250,
                supportedScanTypes: [Html5QrcodeSupportedFormats.QR_CODE],
                experimentalFeatures: {
                    useBarCodeDetectorIfSupported: false
                }
            },
            onScanSuccess
        );
    }

    function stopScanner() {
        if (html5QrScanner) {
            html5QrScanner.stop().then(() => {
                document.getElementById('start-btn').classList.remove('hidden');
                document.getElementById('stop-btn').classList.add('hidden');
                addLog('Scanner stopped.', 'info');
            });
        }
    }
</script>
@endsection

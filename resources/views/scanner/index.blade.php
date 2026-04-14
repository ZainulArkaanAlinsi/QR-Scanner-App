@extends('layouts.app')

@section('title', 'HUD Scanner | Scanner Core')
@section('header', 'System Ingress')

@section('content')
<div class="max-w-6xl mx-auto space-y-10 animate-in fade-in zoom-in duration-500">
    
    <!-- Meta Data Bar -->
    <div class="flex items-center justify-between px-6 py-3 bg-zinc-900 border border-border-subtle rounded-lg font-mono text-[10px] tracking-widest text-text-description">
        <div class="flex items-center space-x-6">
            <span>MODULE: SYNC_SCANNER_V3</span>
            <span>STATUS: <span class="text-brand-success">READY</span></span>
        </div>
        <div class="flex items-center space-x-6">
             <span>CAM_SOURCE: environment</span>
             <span x-data="{ time: new Date().toLocaleTimeString() }" x-init="setInterval(() => time = new Date().toLocaleTimeString(), 1000)" x-text="'UTC: ' + time"></span>
        </div>
    </div>

    <!-- Scanner Section -->
    <div class="grid grid-cols-1 lg:grid-cols-12 gap-6">
        
        <!-- Camera HUD (Left) -->
        <div class="lg:col-span-8 flex flex-col space-y-6">
            <div class="relative bento-card border-brand-primary/20 aspect-video bg-black overflow-hidden group">
                <!-- html5-qrcode reader -->
                <div id="reader" class="w-full h-full scale-[1.02]"></div>

                <!-- HUD Overlays -->
                <div class="absolute inset-0 pointer-events-none">
                    <!-- Target Crosshair -->
                    <div class="absolute inset-0 flex items-center justify-center">
                        <div class="w-64 h-64 border border-brand-primary/30 relative">
                            <!-- Corners (HUD Style) -->
                            <div class="absolute -top-1 -left-1 w-6 h-6 border-t-2 border-l-2 border-brand-primary"></div>
                            <div class="absolute -top-1 -right-1 w-6 h-6 border-t-2 border-r-2 border-brand-primary"></div>
                            <div class="absolute -bottom-1 -left-1 w-6 h-6 border-b-2 border-l-2 border-brand-primary"></div>
                            <div class="absolute -bottom-1 -right-1 w-6 h-6 border-b-2 border-r-2 border-brand-primary"></div>
                            
                            <!-- Internal Guide -->
                            <div class="absolute inset-8 border border-white/5 bg-brand-primary/5"></div>
                            
                            <!-- Scanning Laser Line -->
                            <div class="absolute top-0 left-0 w-full h-px bg-brand-primary shadow-[0_0_15px_rgba(59,130,246,0.5)] animate-[scan_3s_linear_infinite]"></div>
                        </div>
                    </div>

                    <!-- HUD Metadata -->
                    <div class="absolute top-4 left-4 font-mono text-[9px] text-brand-primary space-y-1">
                        <p>X-AXIS: 102.44</p>
                        <p>Y-AXIS: 882.11</p>
                        <p>FOCAL: AUTO</p>
                    </div>
                    <div class="absolute bottom-4 right-4 font-mono text-[9px] text-brand-primary text-right">
                        <p>DATA_STREAM: CONNECTED</p>
                        <p>ENCRYPTION: AES_256</p>
                    </div>
                </div>

                <!-- Status Flash Overlays -->
                <div id="success-flash" class="absolute inset-0 bg-brand-success hidden items-center justify-center text-black font-black text-6xl italic transition-opacity">VALID</div>
                <div id="error-flash" class="absolute inset-0 bg-brand-danger hidden items-center justify-center text-white font-black text-6xl italic transition-opacity">DENIED</div>
            </div>

            <!-- Controls -->
            <div class="flex items-center justify-center space-x-4">
                 <button id="start-btn" onclick="startScanner()" class="btn-primary space-x-2 w-48">
                    <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM9.555 7.168A1 1 0 008 8v4a1 1 0 001.555.832l3-2a1 1 0 000-1.664l-3-2z" clip-rule="evenodd" /></svg>
                    <span>INITIALIZE</span>
                 </button>
                 <button id="stop-btn" onclick="stopScanner()" class="btn-secondary hidden w-48 italic">TERMINATE</button>
            </div>
        </div>

        <!-- Feedback & Logs (Right) -->
        <div class="lg:col-span-4 flex flex-col space-y-6">
            
            <!-- Result Card -->
            <div x-data="{ state: 'idle', data: {} }" 
                 @scan-result.window="state = $event.detail.status; data = $event.detail.payload"
                 class="bento-card p-6 min-h-[220px] relative overflow-hidden flex flex-col items-center justify-center text-center">
                
                <div x-show="state === 'idle'" class="space-y-4">
                    <div class="w-12 h-12 bg-zinc-900 border border-border-subtle rounded-full flex items-center justify-center mx-auto">
                        <svg class="w-6 h-6 text-text-description animate-pulse" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                    </div>
                    <p class="text-xs font-bold text-text-description uppercase tracking-widest">Awaiting Input Signal</p>
                </div>

                <div x-show="state === 'success'" class="w-full space-y-4 animate-in fade-in zoom-in duration-300">
                     <div class="text-xs font-bold text-brand-success uppercase tracking-widest px-3 py-1 bg-brand-success/10 rounded-full inline-block">Authenticated</div>
                     <h3 class="text-3xl font-black text-white italic" x-text="data.name"></h3>
                     <div class="text-left bg-zinc-900 p-4 rounded-lg font-mono text-[10px] space-y-2">
                         <p><span class="text-text-description">UID:</span> <span class="text-white" x-text="data.id"></span></p>
                         <p><span class="text-text-description">TIME:</span> <span class="text-white" x-text="data.time"></span></p>
                         <p><span class="text-text-description">EVNT:</span> <span class="text-white">GLOBAL_SUMMIT_26</span></p>
                     </div>
                </div>

                <div x-show="state === 'error'" class="w-full space-y-4 animate-in fade-in zoom-in duration-300">
                     <div class="text-xs font-bold text-brand-danger uppercase tracking-widest px-3 py-1 bg-brand-danger/10 rounded-full inline-block">Security Breach</div>
                     <p class="text-text-dim text-sm" x-text="data.message"></p>
                </div>

            </div>

            <!-- Mini Terminal Log -->
            <div class="bento-card flex-1 min-h-[300px] p-0 font-mono text-[10px]">
                 <div class="px-4 py-3 border-b border-border-subtle flex items-center justify-between">
                     <span class="font-bold uppercase tracking-widest">Session.log</span>
                     <span class="w-2 h-2 rounded-full bg-brand-success"></span>
                 </div>
                 <div id="terminal-body" class="p-4 space-y-2 overflow-y-auto h-[250px] scrollbar-thin scrollbar-thumb-zinc-800">
                      <p class="text-text-description">> Booting scan_engine_v3.8...</p>
                      <p class="text-brand-success">> System link established.</p>
                      <p class="text-text-description">> Ready for ingress stream.</p>
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
        
        addLog(`Signal detected: ${decodedText.substring(0, 15)}...`, 'info');
        
        const successFlash = document.getElementById('success-flash');
        const errorFlash = document.getElementById('error-flash');
        const auth = Alpine.store('auth');

        if (!auth.token) {
            addLog('Error: No Admin Token configured in Session Settings.', 'error');
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
                addLog('Signature valid. Access granted.', 'success');
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
                addLog(`Denied: ${result.message}`, 'error');
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
            addLog(`Network/System Error: ${err.message}`, 'error');
            beep(150, 400);
            setTimeout(() => html5QrScanner.resume(), 2000);
        });
    }

    function startScanner() {
        document.getElementById('start-btn').classList.add('hidden');
        document.getElementById('stop-btn').classList.remove('hidden');
        addLog('Cam stream initialized. Port 8080 open.', 'info');
        
        html5QrScanner = new Html5Qrcode("reader");
        html5QrScanner.start({ facingMode: "environment" }, { fps: 15, qrbox: 250 }, onScanSuccess);
    }

    function stopScanner() {
        if (html5QrScanner) {
            html5QrScanner.stop().then(() => {
                document.getElementById('start-btn').classList.remove('hidden');
                document.getElementById('stop-btn').classList.add('hidden');
                addLog('Stream terminated. Session saved.', 'info');
            });
        }
    }
</script>
@endsection

@extends('layouts.app')

@section('title', 'Dashboard | Scanner Core')
@section('header', 'System Overview')

@section('content')
<div class="space-y-10 animate-in fade-in slide-in-from-bottom-4 duration-500">
    
    <!-- Hero / Stats Header -->
    <div class="flex flex-col lg:flex-row lg:items-end justify-between gap-6">
        <div>
            <h1 class="text-3xl font-bold tracking-tight text-white">Console</h1>
            <p class="text-text-dim mt-1">Real-time telemetry and management interface.</p>
        </div>
        <div class="flex items-center space-x-3">
             <div class="flex items-center px-3 py-1 bg-zinc-900 border border-border-subtle rounded-md">
                 <div class="w-2 h-2 rounded-full bg-brand-success animate-pulse mr-2"></div>
                 <span class="text-[10px] font-bold uppercase tracking-widest text-text-description">Server Live</span>
             </div>
             <button class="btn-primary" onclick="window.print()">Print Report</button>
        </div>
    </div>

    <!-- Bento Grid -->
    <div class="grid grid-cols-1 md:grid-cols-6 lg:grid-cols-12 gap-4">
        
        <!-- Large Primary Stat Card -->
        <div class="md:col-span-3 lg:col-span-4 bento-card p-6 min-h-[160px] justify-between">
            <div class="flex items-start justify-between">
                <span class="text-xs font-bold text-text-description uppercase tracking-tighter">Activity Volume</span>
                <svg class="w-4 h-4 text-text-description" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6"/></svg>
            </div>
            <div>
                <h2 class="text-4xl font-black text-white italic">{{ $stats['event_velocity'] }}</h2>
                <p class="text-[10px] text-brand-success font-bold mt-1 uppercase tracking-widest">Aggregate Throughput</p>
            </div>
            <!-- Mini Sparkline Simulation -->
            <div class="flex items-end space-x-1 h-8 mt-4">
                <div class="flex-1 bg-zinc-800 h-2 rounded-sm"></div>
                <div class="flex-1 bg-zinc-800 h-4 rounded-sm"></div>
                <div class="flex-1 bg-zinc-800 h-3 rounded-sm"></div>
                <div class="flex-1 bg-brand-primary h-6 rounded-sm"></div>
                <div class="flex-1 bg-brand-primary h-5 rounded-sm"></div>
                <div class="flex-1 bg-brand-primary h-8 rounded-sm"></div>
            </div>
        </div>

        <!-- Medium Stat Cards -->
        <div class="md:col-span-3 lg:col-span-4 bento-card p-6 min-h-[160px] justify-between">
             <div class="flex items-start justify-between">
                <span class="text-xs font-bold text-text-description uppercase tracking-tighter">Total Reservations</span>
                <div class="w-2 h-2 rounded-full bg-brand-primary"></div>
            </div>
            <h2 class="text-4xl font-black text-white italic">{{ number_format($stats['total_tickets']) }}</h2>
            <p class="text-[10px] text-text-description font-bold uppercase tracking-widest">Valid Active Credentials</p>
        </div>

        <!-- Small Status Card -->
        <div class="md:col-span-2 lg:col-span-2 bento-card p-6 justify-center items-center text-center space-y-2">
            <p class="text-[10px] font-bold text-text-description uppercase">Checked In</p>
            <p class="text-2xl font-black italic">{{ number_format($stats['checked_in']) }}</p>
            <div class="w-full h-1 bg-zinc-900 rounded-full overflow-hidden">
                <div class="h-full bg-white" style="width: {{ $stats['total_tickets'] > 0 ? ($stats['checked_in'] / $stats['total_tickets']) * 100 : 0 }}%"></div>
            </div>
        </div>

        <!-- Small Status Card -->
        <div class="md:col-span-2 lg:col-span-2 bento-card p-6 justify-center items-center text-center space-y-2 group">
            <p class="text-[10px] font-bold text-text-description uppercase">Total Events</p>
            <p class="text-2xl font-black italic">{{ $stats['total_events'] }}</p>
            <div class="w-full h-1 bg-zinc-900 rounded-full overflow-hidden">
                <div class="w-full h-full bg-brand-primary opacity-20"></div>
            </div>
        </div>

        <!-- Wide Activity Monitor -->
        <div class="md:col-span-6 bento-card lg:col-span-8 p-0">
             <div class="px-6 py-4 border-b border-border-subtle flex items-center justify-between">
                 <h3 class="text-xs font-bold uppercase tracking-widest">Ingress Stream (Last 6)</h3>
                 <span class="text-[10px] font-mono text-text-description">LIVE_DATA_SYNC</span>
             </div>
             <div class="divide-y divide-border-subtle font-mono text-[11px]">
                  @forelse ($recentCheckins as $checkin)
                  <div class="px-6 py-3 flex items-center justify-between hover:bg-zinc-900/50 transition-colors group">
                      <div class="flex items-center space-x-4">
                          <span class="text-text-description">[{{ $checkin->check_in_at->format('H:i:s') }}]</span>
                          <span class="text-brand-success font-bold">PASS</span>
                          <span class="text-white truncate max-w-[200px]">{{ $checkin->user->name }} -> {{ $checkin->event->name }}</span>
                      </div>
                      <span class="text-text-description group-hover:text-white transition-colors">TKT: {{ substr($checkin->id, 0, 8) }}</span>
                  </div>
                  @empty
                  <div class="px-6 py-12 text-center text-text-description">
                      <p>> NO_INGRESS_DATA_FOUND</p>
                  </div>
                  @endforelse
             </div>
             <div class="px-6 py-3 bg-zinc-900/20 text-center">
                 <a href="/scanner" class="text-[10px] font-bold text-text-description hover:text-white uppercase tracking-widest">Initialize Live Scanner</a>
             </div>
        </div>

        <!-- Side Actions / Profile Summary -->
        <div class="md:col-span-6 lg:col-span-4 bento-card p-6 space-y-6">
            <h3 class="text-xs font-bold uppercase tracking-widest">Upcoming Deployments</h3>
            
            <div class="space-y-3">
                @forelse ($upcomingEvents as $event)
                <div class="bg-zinc-900 border border-border-subtle p-3 rounded-lg flex items-center space-x-4 group hover:border-brand-primary transition-all">
                     <div class="w-10 h-10 rounded bg-zinc-800 flex items-center justify-center shrink-0">
                         <svg class="w-5 h-5 text-text-dim group-hover:text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/></svg>
                     </div>
                     <div class="flex-1 min-w-0">
                         <p class="text-xs font-bold text-white truncate uppercase tracking-tighter">{{ $event->name }}</p>
                         <p class="text-[10px] text-text-description">{{ $event->date->format('M d, Y') }}</p>
                     </div>
                </div>
                @empty
                <div class="p-8 text-center border border-dashed border-border-subtle rounded-lg">
                    <p class="text-[10px] text-text-description uppercase tracking-widest italic">No deployments scheduled</p>
                </div>
                @endforelse
            </div>
            
            <div class="pt-4 grid grid-cols-2 gap-3">
                 <a href="/events" class="bg-zinc-900 border border-border-subtle p-3 rounded-lg flex flex-col items-center justify-center space-y-1 hover:border-brand-primary transition-all group">
                     <svg class="w-4 h-4 text-text-dim group-hover:text-brand-primary" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"/></svg>
                     <span class="text-[9px] font-bold uppercase">Registry</span>
                 </a>
                 <button @click="configOpen = true" class="bg-zinc-900 border border-border-subtle p-3 rounded-lg flex flex-col items-center justify-center space-y-1 hover:border-brand-primary transition-all group">
                     <svg class="w-4 h-4 text-text-dim group-hover:text-brand-primary" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924-1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37a1.724 1.724 0 002.572-1.065z"/><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/></svg>
                     <span class="text-[9px] font-bold uppercase">Config</span>
                 </button>
            </div>
        </div>

    </div>
</div>
@endsection

@extends('layouts.app')

@section('title', 'Dashboard | Scanner Core')
@section('header', 'System Overview')

@section('content')
<div class="space-y-8 animate-in fade-in slide-in-from-bottom-4 duration-700">
    
    <!-- Hero Header -->
    <div class="flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
            <h1 class="text-2xl font-bold tracking-tight text-text-bright">Dashboard Overview</h1>
            <p class="text-sm text-text-dim mt-1">Real-time statistics and ticket activity</p>
        </div>
        <div class="flex items-center space-x-3">
             <div class="hidden sm:flex items-center px-3 py-1 bg-bg-card border border-border-subtle rounded-lg shadow-sm">
                 <div class="w-1.5 h-1.5 rounded-full bg-brand-success mr-2 animate-pulse"></div>
                 <span class="text-[10px] font-bold uppercase tracking-wider text-text-dim">Network: Connected</span>
             </div>
             <button class="btn-primary space-x-2" onclick="window.print()">
                <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M12 10v6m0 0l-3-3m3 3l3-3m2 8H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/></svg>
                <span>Export Report</span>
             </button>
        </div>
    </div>

    <!-- Stats Grid -->
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-5">
        
        <!-- Total Tickets -->
        <div class="bento-card p-6 min-h-[140px] group transition-all">
            <div class="flex items-center justify-between">
                <div class="p-2 bg-brand-primary/10 rounded-xl text-brand-primary">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 5v2m0 4v2m0 4v2M5 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z"/></svg>
                </div>
                <span class="text-[10px] font-bold text-brand-success p-1 px-2 bg-brand-success/10 rounded-full">+12.5%</span>
            </div>
            <div class="mt-4">
                <p class="text-3xl font-bold text-text-bright tracking-tight">{{ number_format($stats['total_tickets']) }}</p>
                <p class="text-xs font-semibold text-text-dim mt-1">Total Issued Tickets</p>
            </div>
        </div>

        <!-- Scan Velocity -->
        <div class="bento-card p-6 min-h-[140px] group">
            <div class="flex items-center justify-between">
                <div class="p-2 bg-blue-500/10 rounded-xl text-blue-500">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"/></svg>
                </div>
                <div class="flex space-x-1 items-end h-4">
                    <div class="w-1 bg-blue-500/30 h-1 rounded-full"></div>
                    <div class="w-1 bg-blue-500/50 h-2 rounded-full"></div>
                    <div class="w-1 bg-blue-500 h-3 rounded-full"></div>
                </div>
            </div>
            <div class="mt-4">
                <p class="text-3xl font-bold text-text-bright tracking-tight">{{ $stats['event_velocity'] }} <span class="text-sm font-medium text-text-dim uppercase">t/s</span></p>
                <p class="text-xs font-semibold text-text-dim mt-1">Average Scan Speed</p>
            </div>
        </div>

        <!-- Total Events -->
        <div class="bento-card p-6 min-h-[140px] group">
            <div class="flex items-center justify-between">
                <div class="p-2 bg-orange-500/10 rounded-xl text-orange-500">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/></svg>
                </div>
            </div>
            <div class="mt-4">
                <p class="text-3xl font-bold text-text-bright tracking-tight">{{ $stats['total_events'] }}</p>
                <p class="text-xs font-semibold text-text-dim mt-1">Active Events</p>
            </div>
        </div>

        <!-- Checkin Efficiency -->
        <div class="bento-card p-6 min-h-[140px] group">
            <div class="flex items-center justify-between">
                <div class="p-2 bg-brand-success/10 rounded-xl text-brand-success">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                </div>
                <span class="text-[10px] font-bold text-text-dim">{{ number_format($stats['checked_in']) }} Total</span>
            </div>
            <div class="mt-4">
                @php $percent = $stats['total_tickets'] > 0 ? ($stats['checked_in'] / $stats['total_tickets']) * 100 : 0; @endphp
                <p class="text-3xl font-bold text-text-bright tracking-tight">{{ number_format($percent, 1) }}%</p>
                <div class="w-full h-1.5 bg-bg-elevated rounded-full mt-2 overflow-hidden">
                    <div class="h-full bg-brand-success rounded-full" style="width: {{ $percent }}%"></div>
                </div>
            </div>
        </div>
    </div>

    <!-- Main Content Area -->
    <div class="grid grid-cols-1 lg:grid-cols-12 gap-8">
        
        <!-- Live Stream Table -->
        <div x-data="{ 
                refreshing: false, 
                lastUpdated: new Date().toLocaleTimeString(),
                async refresh() {
                    this.refreshing = true;
                    setTimeout(() => { window.location.reload(); }, 500);
                }
             }" 
             class="lg:col-span-8 bento-card shadow-lg border-none overflow-hidden flex flex-col">
             
             <div class="px-6 py-5 border-b border-border-subtle bg-bg-card flex items-center justify-between">
                  <div class="flex items-center space-x-3">
                    <h3 class="text-sm font-bold text-text-bright">Live Attendance Feed</h3>
                    <span class="flex items-center px-2 py-0.5 bg-brand-success/10 text-brand-success border border-brand-success/20 rounded-md text-[9px] font-bold uppercase tracking-wider">
                        <span class="w-1 h-1 rounded-full bg-brand-success mr-1.5 animate-pulse"></span>
                        Live
                    </span>
                  </div>
                  <div class="flex items-center space-x-4">
                    <span class="hidden sm:block text-[10px] font-medium text-text-dim uppercase tracking-wider" x-text="'Updated: ' + lastUpdated"></span>
                    <button @click="refresh()" :class="refreshing ? 'animate-spin' : ''" class="text-text-description hover:text-brand-primary transition-all p-1">
                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"/></svg>
                    </button>
                  </div>
             </div>

             <div class="overflow-x-auto">
                 <table class="w-full text-left border-collapse">
                     <thead class="bg-bg-elevated/50 text-[10px] font-bold uppercase tracking-wider text-text-dim border-b border-border-subtle">
                         <tr>
                             <th class="px-6 py-3">Time</th>
                             <th class="px-6 py-3">Attendee</th>
                             <th class="px-6 py-3">Ticket ID</th>
                             <th class="px-6 py-3 text-right">Status</th>
                         </tr>
                     </thead>
                     <tbody class="divide-y divide-border-subtle/50">
                          @forelse ($recentCheckins as $checkin)
                           <tr class="hover:bg-bg-elevated/30 transition-colors group">
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <span class="text-xs font-medium text-text-dim">{{ $checkin->check_in_at->format('H:i:s') }}</span>
                                </td>
                                <td class="px-6 py-4">
                                    <div class="flex items-center space-x-3">
                                        <div class="w-7 h-7 rounded-lg bg-bg-elevated flex items-center justify-center text-[10px] font-bold text-brand-primary">
                                            {{ substr($checkin->user->name, 0, 1) }}
                                        </div>
                                        <span class="text-xs font-bold text-text-bright">{{ $checkin->user->name }}</span>
                                    </div>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <span class="text-[10px] font-mono font-bold text-text-dim group-hover:text-brand-primary transition-colors">#{{ strtoupper(substr($checkin->id, 0, 8)) }}</span>
                                </td>
                                <td class="px-6 py-4 text-right">
                                    <span class="px-2 py-0.5 bg-brand-success/10 text-brand-success text-[9px] font-bold rounded-md uppercase tracking-tighter">Verified</span>
                                </td>
                           </tr>
                          @empty
                          <tr>
                              <td colspan="4" class="px-6 py-12 text-center">
                                  <div class="flex flex-col items-center">
                                      <svg class="w-8 h-8 text-text-description mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 13V6a2 2 0 00-2-2H6a2 2 0 00-2 2v7m16 0v5a2 2 0 01-2 2H6a2 2 0 01-2-2v-5m16 0h-2.586a1 1 0 00-.707.293l-2.414 2.414a1 1 0 01-.707.293h-3.172a1 1 0 01-.707-.293l-2.414-2.414A1 1 0 006.586 13H4"/></svg>
                                      <p class="text-xs text-text-dim">No check-ins recorded yet</p>
                                  </div>
                              </td>
                          </tr>
                          @endforelse
                     </tbody>
                 </table>
             </div>

             <div class="mt-auto px-6 py-4 bg-bg-elevated/30 border-t border-border-subtle">
                 <a href="/scanner" class="flex items-center justify-center space-x-2 text-xs font-bold text-text-dim hover:text-brand-primary transition-colors">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v1m6 11h2m-6 0h-2v4m0-11v3m0 0h.01M12 12h4.01M16 20h4M4 12h4m12 0h.01M5 8h2a1 1 0 001-1V5a1 1 0 00-1-1H5a1 1 0 00-1 1v2a1 1 0 001 1zm12 0h2a1 1 0 001-1V5a1 1 0 00-1-1h-2a1 1 0 00-1 1v2a1 1 0 001 1zM5 20h2a1 1 0 001-1v-2a1 1 0 00-1-1H5a1 1 0 00-1 1v2a1 1 0 001 1z"/></svg>
                    <span>Open Live Scanner Console</span>
                 </a>
             </div>
        </div>

        <!-- Sidebar Actions -->
        <div class="lg:col-span-4 space-y-6">
            
            <!-- Quick Actions -->
            <div class="bento-card p-6">
                <h3 class="text-xs font-bold uppercase tracking-wider text-text-dim mb-4">Quick Links</h3>
                <div class="grid grid-cols-2 gap-3">
                     <a href="/events" class="flex flex-col items-center justify-center p-4 bg-bg-elevated/50 border border-border-subtle rounded-xl hover:border-brand-primary transition-all group">
                         <div class="p-2 bg-white dark:bg-bg-card rounded-lg shadow-sm mb-2 group-hover:text-brand-primary">
                             <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"/></svg>
                         </div>
                         <span class="text-[10px] font-bold uppercase tracking-widest">Events</span>
                     </a>
                     <button @click="configOpen = true" class="flex flex-col items-center justify-center p-4 bg-bg-elevated/50 border border-border-subtle rounded-xl hover:border-brand-primary transition-all group">
                         <div class="p-2 bg-white dark:bg-bg-card rounded-lg shadow-sm mb-2 group-hover:text-brand-primary">
                             <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924-1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37a1.724 1.724 0 002.572-1.065z"/><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/></svg>
                         </div>
                         <span class="text-[10px] font-bold uppercase tracking-widest">Settings</span>
                     </button>
                </div>
            </div>

            <!-- Upcoming Events -->
            <div class="bento-card p-6">
                <div class="flex items-center justify-between mb-4">
                    <h3 class="text-xs font-bold uppercase tracking-wider text-text-dim">Upcoming Events</h3>
                    <a href="/events" class="text-[10px] font-bold text-brand-primary hover:underline">View All</a>
                </div>
                
                <div class="space-y-3">
                    @forelse ($upcomingEvents as $event)
                    <div class="bg-white dark:bg-bg-elevated/40 border border-border-subtle p-3 rounded-xl flex items-center space-x-3 group hover:border-brand-primary/30 transition-all">
                         <div class="px-2 py-1 bg-bg-elevated rounded-lg text-center min-w-[44px]">
                             <p class="text-[8px] font-bold uppercase text-text-dim">{{ $event->date->format('M') }}</p>
                             <p class="text-xs font-bold text-brand-primary">{{ $event->date->format('d') }}</p>
                         </div>
                         <div class="flex-1 min-w-0">
                             <p class="text-xs font-bold text-text-bright truncate">{{ $event->name }}</p>
                             <p class="text-[10px] text-text-dim">{{ $event->date->format('Y') }} • 09:00 AM</p>
                         </div>
                    </div>
                    @empty
                    <div class="py-10 text-center border-2 border-dashed border-border-subtle rounded-xl">
                        <p class="text-[10px] font-bold text-text-description uppercase tracking-widest">Clear Schedule</p>
                    </div>
                    @endforelse
                </div>
            </div>
            
        </div>

    </div>
</div>
@endsection

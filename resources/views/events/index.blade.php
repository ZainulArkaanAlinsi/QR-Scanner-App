@extends('layouts.app')

@section('title', 'Registry | Scanner Core')
@section('header', 'Event Registry')

@section('content')
<div x-data="{ createModal: false }" class="space-y-10 animate-in fade-in slide-in-from-bottom-4 duration-500">
    
    <!-- Toast Notification -->
    @if(session('success'))
    <div x-data="{ show: true }" x-show="show" x-init="setTimeout(() => show = false, 5000)" 
         class="fixed top-6 right-6 z-100 flex items-center p-4 bg-brand-success/10 border border-brand-success/30 rounded-lg backdrop-blur-md animate-in fade-in slide-in-from-top-4">
        <div class="flex items-center space-x-3 bg-brand-success/5 px-3 py-1.5 rounded border border-brand-success/20">
            <span class="w-1.5 h-1.5 rounded-full bg-brand-success shadow-[0_0_8px_rgba(5,150,105,1)]"></span>
            <span class="text-[9px] font-mono font-black text-brand-success tracking-[0.2em] uppercase">{{ session('success') }}</span>
        </div>
        <button @click="show = false" class="ml-8 text-brand-success/60 hover:text-brand-success"><svg class="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path d="M6 18L18 6M6 6l12 12"/></svg></button>
    </div>
    @endif

    <!-- Header -->
    <div class="flex flex-col md:flex-row md:items-center justify-between gap-6">
        <div>
            <h1 class="text-2xl font-black tracking-tighter text-text-bright uppercase italic">Registry</h1>
            <p class="text-text-dim mt-1 text-xs font-medium">Authorized event manifests and participant quotas.</p>
        </div>
        <button @click="createModal = true" class="btn-primary flex items-center space-x-3 group px-8">
            <svg class="w-4 h-4 transition-transform group-hover:rotate-90" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/></svg>
            <span class="tracking-tight uppercase font-black">NEW_DEPLOYMENT</span>
        </button>
    </div>

    <!-- Main Content & Modal Wrapper -->
    <div class="relative">
        <!-- Filters Table Bar -->
        <div class="flex items-center justify-between px-6 py-4 bg-bg-card/40 backdrop-blur-xl border border-border-subtle/50 rounded-t-xl border-b-0 relative overflow-hidden group">
            <div class="absolute inset-0 opacity-[0.02] pointer-events-none" style="background-image: radial-gradient(circle, currentColor 0.5px, transparent 0.5px); background-size: 10px 10px;"></div>
            <div class="flex items-center space-x-8 relative z-10">
                <button class="technical-label text-brand-primary opacity-100 border-b-2 border-brand-primary pb-1">Active_Manifests</button>
                <button class="technical-label hover:text-text-bright transition-colors">Archived_Logs</button>
            </div>
            <div class="flex items-center space-x-3 relative z-10">
                <span class="px-3 py-1 bg-bg-elevated/50 rounded-full border border-border-subtle/30 technical-label text-text-description italic">Total_Nodes: {{ str_pad($events->total(), 2, '0', STR_PAD_LEFT) }}</span>
            </div>
        </div>

        <!-- Main Table -->
        <div class="bento-card rounded-t-none border-t-0 overflow-hidden shadow-2xl">
            <div class="overflow-x-auto">
                <table class="w-full text-left font-mono text-[11px] border-collapse">
                    <thead class="bg-bg-elevated/30 border-b border-border-subtle/50 text-text-dim uppercase tracking-widest italic">
                        <tr class="technical-label text-text-description/40 italic">
                            <th class="px-6 py-4">Entry_ID</th>
                            <th class="px-6 py-4">Manifest_Identity</th>
                            <th class="px-6 py-4">Deploy_TS</th>
                            <th class="px-6 py-4">Quorum_Fill</th>
                            <th class="px-6 py-4">Signal_Stat</th>
                            <th class="px-6 py-4 text-right">Interactions</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-border-subtle/30 bg-bg-card/20">
                        @forelse ($events as $event)
                        <tr class="group hover:bg-bg-elevated/40 transition-colors">
                            <td class="px-6 py-4 whitespace-nowrap text-text-description">#{{ substr($event->id, 0, 8) }}</td>
                            <td class="px-6 py-4 whitespace-nowrap">
                                <div class="flex items-center space-x-4">
                                    <div class="w-8 h-8 bg-bg-elevated rounded flex items-center justify-center shrink-0 border border-border-subtle overflow-hidden">
                                        @if($event->images && count($event->images) > 0)
                                            <img src="{{ (strpos($event->images[0], 'http') !== false) ? $event->images[0] : asset('storage/' . $event->images[0]) }}" class="w-full h-full object-cover opacity-60">
                                        @else
                                            <svg class="w-4 h-4 text-text-dim" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"/></svg>
                                        @endif
                                    </div>
                                    <span class="font-bold text-text-bright uppercase tracking-tight truncate max-w-[200px]">{{ $event->name }}</span>
                                </div>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-text-dim">{{ $event->date->format('M d, Y') }}</td>
                            <td class="px-8 py-5 whitespace-nowrap">
                                <div class="w-32 space-y-2">
                                    @php
                                        $percent = $event->max_reservation > 0 ? ($event->tickets_count / $event->max_reservation) * 100 : 0;
                                    @endphp
                                    <div class="flex justify-between text-[9px] font-black tracking-widest text-text-description">
                                        <span class="text-brand-primary">{{ number_format($percent, 0) }}%</span>
                                        <span>{{ $event->tickets_count }}/{{ $event->max_reservation }}</span>
                                    </div>
                                    <div class="w-full h-1.5 bg-bg-elevated rounded-full overflow-hidden border border-border-subtle/30">
                                        <div class="h-full bg-brand-primary shadow-[0_0_10px_rgba(36,210,171,0.5)]" style="width: {{ $percent }}%"></div>
                                    </div>
                                </div>
                            </td>
                            <td class="px-8 py-5 whitespace-nowrap">
                                @if($event->date >= now())
                                    <span class="inline-flex items-center px-3 py-1 rounded-full border border-brand-primary/30 bg-brand-primary/10 text-brand-primary text-[9px] font-black uppercase tracking-widest shadow-[0_0_15px_rgba(36,210,171,0.1)]">
                                        <span class="w-1.5 h-1.5 rounded-full bg-brand-primary animate-pulse mr-2.5 shadow-[0_0_8px_rgba(36,210,171,0.5)]"></span>
                                        Operational
                                    </span>
                                @else
                                    <span class="inline-flex items-center px-3 py-1 rounded-full border border-border-subtle bg-bg-elevated/50 text-text-description text-[9px] font-black uppercase tracking-widest">
                                        Archived_Log
                                    </span>
                                @endif
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-right">
                                <div class="flex items-center justify-end space-x-3 opacity-0 group-hover:opacity-100 transition-opacity">
                                    <button class="text-text-dim hover:text-text-bright transition-colors">
                                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z"/></svg>
                                    </button>
                                    <form action="{{ route('events.destroy', $event->id) }}" method="POST" onsubmit="return confirm('CONFIRM_DECOMMISSION: This will permanently wipe all associated telemetry and tickets. Proceed?')" class="inline">
                                        @csrf
                                        @method('DELETE')
                                        <button type="submit" class="text-brand-danger/40 hover:text-brand-danger transition-colors">
                                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/></svg>
                                        </button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                        @empty
                        <tr>
                            <td colspan="6" class="px-6 py-12 text-center text-text-description italic">
                                > NO_EVENT_MANIFESTS_LOADED
                            </td>
                        </tr>
                        @endforelse
                    </tbody>
                </table>
            </div>
            
            <!-- Pagination -->
            @if($events->hasPages())
            <div class="px-8 py-5 bg-bg-card/50 border-t border-border-subtle/50 backdrop-blur-md flex items-center justify-between">
                <span class="text-[10px] text-text-description font-black tracking-widest">SYS_INDEX: [{{ str_pad($events->currentPage(), 2, '0', STR_PAD_LEFT) }}/{{ str_pad($events->lastPage(), 2, '0', STR_PAD_LEFT) }}]</span>
                <div class="flex items-center space-x-3">
                    @if($events->onFirstPage())
                        <button class="p-2 px-4 bg-bg-elevated border border-border-subtle rounded-xl opacity-30 cursor-not-allowed"><svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"/></svg></button>
                    @else
                        <a href="{{ $events->previousPageUrl() }}" class="p-2 px-4 bg-bg-card border border-border-subtle rounded-xl hover:border-brand-primary hover:text-brand-primary transition-all"><svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"/></svg></a>
                    @endif
 
                    @if($events->hasMorePages())
                        <a href="{{ $events->nextPageUrl() }}" class="p-2 px-4 bg-bg-card border border-border-subtle rounded-xl hover:border-brand-primary hover:text-brand-primary transition-all"><svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/></svg></a>
                    @else
                        <button class="p-2 px-4 bg-bg-elevated border border-border-subtle rounded-xl opacity-30 cursor-not-allowed"><svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/></svg></button>
                    @endif
                </div>
            </div>
            @endif
        </div>

        <!-- Creation Modal -->
         <div x-show="createModal" 
              class="fixed inset-0 z-100 flex items-center justify-center p-6 bg-bg-main/90 backdrop-blur-md"
              x-transition:enter="transition ease-out duration-300"
              x-transition:enter-start="opacity-0 scale-95"
              x-transition:enter-end="opacity-100 scale-100"
              x-transition:leave="transition ease-in duration-200"
              x-transition:leave-start="opacity-100 scale-100"
              x-transition:leave-end="opacity-0 scale-95"
              x-cloak>
            <div @click.away="createModal = false" class="bento-card w-full max-w-2xl p-0 overflow-hidden border-brand-primary/20 shadow-2xl">
                <div class="px-10 py-8 border-b border-border-subtle/50 flex items-center justify-between bg-bg-card/80 backdrop-blur-xl">
                    <div>
                        <h3 class="text-xl font-black tracking-tighter text-text-bright uppercase italic">New manifest deployment</h3>
                        <p class="text-[9px] font-black text-brand-primary tracking-[0.3em] mt-1 uppercase italic shadow-[0_0_10px_rgba(36,210,171,0.2)]">> initialize_node_parameters</p>
                    </div>
                    <button @click="createModal = false" class="w-10 h-10 rounded-full bg-bg-elevated border border-border-subtle flex items-center justify-center text-text-dim hover:text-brand-primary transition-all cursor-pointer"><svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path d="M6 18L18 6M6 6l12 12"/></svg></button>
                </div>

                <form action="{{ route('events.store') }}" method="POST" enctype="multipart/form-data" class="p-8 space-y-8">
                    @csrf
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-8 font-mono text-[11px]">
                        <!-- Left Col -->
                        <div class="space-y-6">
                            <div class="space-y-2">
                                <label class="block text-[10px] font-black uppercase tracking-[0.2em] text-text-dim italic">> MANIFEST_NAME</label>
                                <input type="text" name="name" required placeholder="EVENT_TITLE" 
                                       class="w-full bg-bg-elevated/50 border border-border-subtle rounded-xl px-4 py-3 text-sm text-text-bright focus:outline-none focus:border-brand-primary transition-all focus:ring-4 focus:ring-brand-primary/10">
                            </div>
                            <div class="space-y-2">
                                <label class="block text-[10px] font-black uppercase tracking-[0.2em] text-text-dim italic">> DEPLOY_DATE</label>
                                <input type="date" name="date" required 
                                       class="w-full bg-bg-elevated/50 border border-border-subtle rounded-xl px-4 py-3 text-sm text-text-bright focus:outline-none focus:border-brand-primary transition-all focus:ring-4 focus:ring-brand-primary/10">
                            </div>
                            <div class="space-y-2">
                                <label class="block text-[10px] font-black uppercase tracking-[0.2em] text-text-dim italic">> CAPACITY_LIMIT</label>
                                <input type="number" name="max_reservation" required min="1" placeholder="500" 
                                       class="w-full bg-bg-elevated/50 border border-border-subtle rounded-xl px-4 py-3 text-sm text-text-bright focus:outline-none focus:border-brand-primary transition-all focus:ring-4 focus:ring-brand-primary/10">
                            </div>
                        </div>

                        <!-- Right Col -->
                        <div class="space-y-6">
                            <div class="space-y-2">
                                <label class="block text-[10px] font-black uppercase tracking-[0.2em] text-text-dim italic">> DESCRIPTION_MANIFEST</label>
                                <textarea name="description" required rows="4" placeholder="EVENT_DETAILS..." 
                                          class="w-full bg-bg-elevated/50 border border-border-subtle rounded-xl px-4 py-3 text-sm text-text-bright focus:outline-none focus:border-brand-primary transition-all focus:ring-4 focus:ring-brand-primary/10 resize-none"></textarea>
                            </div>
                            <div class="space-y-2">
                                <label class="block text-[10px] font-black uppercase tracking-[0.2em] text-text-dim italic">> VISUAL_ASSETS</label>
                                <div class="relative group">
                                    <input type="file" name="images[]" multiple required accept="image/*"
                                           class="absolute inset-0 w-full h-full opacity-0 cursor-pointer z-10">
                                    <div class="w-full border-2 border-dashed border-border-subtle rounded-2xl py-6 flex flex-col items-center justify-center text-text-dim group-hover:border-brand-primary group-hover:bg-brand-primary/5 transition-all">
                                        <svg class="w-6 h-6 mb-2 text-brand-primary" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-8l-4-4m0 0L8 8m4-4v12"/></svg>
                                        <span class="text-[10px] font-black uppercase tracking-widest">UPLOAD_SYMBOLS</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="pt-10 border-t border-border-subtle/50 flex flex-col sm:flex-row items-center justify-between gap-6">
                        <div class="flex items-center space-x-3 text-[10px] font-black text-brand-primary">
                            <span class="w-2 h-2 rounded-full bg-brand-primary animate-pulse shadow-[0_0_10px_rgba(36,210,171,0.6)]"></span>
                            <span class="italic uppercase tracking-[0.3em]">Ready for initialization</span>
                        </div>
                        <div class="flex items-center space-x-6 w-full sm:w-auto">
                            <button type="button" @click="createModal = false" class="text-[11px] font-black uppercase tracking-widest text-text-dim hover:text-text-bright transition-all">ABORT_CMD</button>
                            <button type="submit" class="btn-primary px-10 py-3.5 italic tracking-tight flex items-center space-x-3 flex-1 sm:flex-none">
                                <span class="uppercase font-black">DEPLOY_MANIFEST</span>
                                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path d="M14 5l7 7m0 0l-7 7m7-7H3"/></svg>
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
@endsection

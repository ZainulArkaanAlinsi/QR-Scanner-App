@extends('layouts.app')

@section('title', 'Registry | Scanner Core')
@section('header', 'Event Registry')

@section('content')
<div class="space-y-10 animate-in fade-in slide-in-from-bottom-4 duration-500">
    
    <!-- Header -->
    <div class="flex flex-col md:flex-row md:items-center justify-between gap-6">
        <div>
            <h1 class="text-3xl font-bold tracking-tight text-white">Registry</h1>
            <p class="text-text-dim mt-1">Authorized event manifests and participant quotas.</p>
        </div>
        <button class="btn-primary flex items-center space-x-2">
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/></svg>
            <span>NEW_ENTRY</span>
        </button>
    </div>

    <!-- Filters Table Bar -->
    <div class="flex items-center justify-between px-6 py-4 bg-zinc-900 border border-border-subtle rounded-t-xl border-b-0 font-mono text-[10px] tracking-widest text-text-description">
        <div class="flex items-center space-x-8">
             <button class="text-white border-b border-brand-primary pb-0.5 uppercase">All_Manifests</button>
        </div>
        <div class="flex items-center space-x-2">
            <span>TOTAL_RECORDS: {{ str_pad($events->total(), 2, '0', STR_PAD_LEFT) }}</span>
        </div>
    </div>

    <!-- Main Table -->
    <div class="bento-card rounded-t-none border-t-0 overflow-hidden">
        <div class="overflow-x-auto">
            <table class="w-full text-left font-mono text-[11px]">
                <thead class="bg-zinc-900/50 border-b border-border-subtle text-text-description uppercase tracking-tighter">
                    <tr>
                        <th class="px-6 py-4 font-bold">Entry ID</th>
                        <th class="px-6 py-4 font-bold">Manifest Name</th>
                        <th class="px-6 py-4 font-bold">Deploy Date</th>
                        <th class="px-6 py-4 font-bold">Capacity</th>
                        <th class="px-6 py-4 font-bold">Status</th>
                        <th class="px-6 py-4 font-bold text-right">Actions</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-border-subtle bg-bg-card">
                    @forelse ($events as $event)
                    <tr class="group hover:bg-zinc-900/40 transition-colors">
                        <td class="px-6 py-4 whitespace-nowrap text-text-description">#{{ substr($event->id, 0, 8) }}</td>
                        <td class="px-6 py-4 whitespace-nowrap">
                            <div class="flex items-center space-x-4">
                                <div class="w-8 h-8 bg-zinc-800 rounded flex items-center justify-center shrink-0 border border-zinc-700 overflow-hidden">
                                    @if($event->images && count($event->images) > 0)
                                        <img src="{{ $event->images[0] }}" class="w-full h-full object-cover opacity-60">
                                    @else
                                        <svg class="w-4 h-4 text-text-dim" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"/></svg>
                                    @endif
                                </div>
                                <span class="font-bold text-white uppercase tracking-tight truncate max-w-[200px]">{{ $event->name }}</span>
                            </div>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap text-text-dim">{{ $event->date->format('M d, Y') }}</td>
                        <td class="px-6 py-4 whitespace-nowrap">
                            <div class="w-32 space-y-1">
                                @php
                                    $percent = $event->max_reservation > 0 ? ($event->tickets_count / $event->max_reservation) * 100 : 0;
                                @endphp
                                <div class="flex justify-between text-[9px] text-text-description">
                                    <span>{{ number_format($percent, 0) }}%</span>
                                    <span>{{ $event->tickets_count }}/{{ $event->max_reservation }}</span>
                                </div>
                                <div class="w-full h-1 bg-zinc-900 rounded-full overflow-hidden">
                                    <div class="h-full bg-brand-primary" style="width: {{ $percent }}%"></div>
                                </div>
                            </div>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap">
                            @if($event->date >= now())
                                <span class="inline-flex items-center px-2 py-0.5 rounded border border-brand-success/20 bg-brand-success/5 text-brand-success text-[10px] font-bold uppercase tracking-widest">
                                    <span class="w-1 h-1 rounded-full bg-brand-success mr-2"></span>
                                    Online
                                </span>
                            @else
                                <span class="inline-flex items-center px-2 py-0.5 rounded border border-border-subtle bg-zinc-900/50 text-text-description text-[10px] font-bold uppercase tracking-widest">
                                    Archived
                                </span>
                            @endif
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap text-right">
                            <div class="flex items-center justify-end space-x-3 opacity-0 group-hover:opacity-100 transition-opacity">
                                <button class="text-text-dim hover:text-white transition-colors">
                                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z"/></svg>
                                </button>
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
        <div class="px-6 py-4 bg-zinc-900/30 border-t border-border-subtle flex items-center justify-between">
            <span class="text-[10px] text-text-description font-mono">PAGE_NAV: [{{ str_pad($events->currentPage(), 2, '0', STR_PAD_LEFT) }}/{{ str_pad($events->lastPage(), 2, '0', STR_PAD_LEFT) }}]</span>
            <div class="flex items-center space-x-2">
                 @if($events->onFirstPage())
                    <button class="p-1 px-3 border border-border-subtle rounded opacity-30 cursor-not-allowed"><svg class="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"/></svg></button>
                 @else
                    <a href="{{ $events->previousPageUrl() }}" class="p-1 px-3 border border-border-subtle rounded hover:bg-zinc-800"><svg class="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"/></svg></a>
                 @endif

                 @if($events->hasMorePages())
                    <a href="{{ $events->nextPageUrl() }}" class="p-1 px-3 border border-border-subtle rounded hover:bg-zinc-800"><svg class="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/></svg></a>
                 @else
                    <button class="p-1 px-3 border border-border-subtle rounded opacity-30 cursor-not-allowed"><svg class="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/></svg></button>
                 @endif
            </div>
        </div>
        @endif
    </div>
</div>
@endsection

<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}" class="h-full scroll-smooth">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="csrf-token" content="{{ csrf_token() }}">

    <title>@yield('title', 'Scanner Core')</title>

    <!-- Fonts -->
    <link rel="preconnect" href="https://rsms.me/">
    <link rel="stylesheet" href="https://rsms.me/inter/inter.css">

    <!-- Styles & Scripts -->
    @vite(['resources/css/app.css', 'resources/js/app.js'])
    
    <!-- Alpine.js -->
    <script defer src="https://unpkg.com/alpinejs@3.x.x/dist/cdn.min.js"></script>

    <script>
        document.addEventListener('alpine:init', () => {
            Alpine.store('auth', {
                token: localStorage.getItem('admin_token') || '',
                apiKey: localStorage.getItem('api_key') || 'K8vskiIaHsvc8NOvBpmAInxvq8YS6kuP',
                setToken(val) { this.token = val; localStorage.setItem('admin_token', val); },
                setApiKey(val) { this.apiKey = val; localStorage.setItem('api_key', val); },
                get headers() {
                    return {
                        'Authorization': `Bearer ${this.token}`,
                        'X-Api-Key': this.apiKey,
                        'Accept': 'application/json',
                        'Content-Type': 'application/json'
                    };
                }
            })
        })
    </script>
</head>
<body class="h-full font-sans antialiased text-text-bright bg-bg-main selection:bg-brand-primary selection:text-white">
    <div x-data="{ sidebarOpen: true, mobileMenu: false, configOpen: false }" class="flex h-screen overflow-hidden bg-bg-main relative">
        
        <!-- Sidebar (Desktop) -->
        <aside :class="sidebarOpen ? 'w-64' : 'w-20'" 
               class="hidden lg:flex flex-col h-full border-r border-border-subtle bg-bg-card transition-all duration-300 ease-in-out z-30">
            
            <!-- Logo Header -->
            <div class="h-16 flex items-center px-6 border-b border-border-subtle overflow-hidden whitespace-nowrap">
                <div class="shrink-0 w-8 h-8 rounded-md bg-white flex items-center justify-center">
                    <svg class="w-5 h-5 text-black" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M3 4a1 1 0 011-1h3a1 1 0 011 1v3a1 1 0 01-1 1H4a1 1 0 01-1-1V4zm2 2V5h1v1H5zM3 13a1 1 0 011-1h3a1 1 0 011 1v3a1 1 0 01-1 1H4a1 1 0 01-1-1v-3zm2 2v-1h1v1H5zM13 3a1 1 0 00-1 1v3a1 1 0 001 1h3a1 1 0 001-1V4a1 1 0 00-1-1h-3zm1 2v1h1V5h-1zM11 13a1 1 0 011-1h3a1 1 0 011 1v3a1 1 0 01-1 1h-3a1 1 0 01-1-1v-3zm2 2v-1h1v1H5z" clip-rule="evenodd" /><path d="M7 10a1 1 0 011-1h1a1 1 0 011 1v1a1 1 0 01-1 1H8a1 1 0 01-1-1v-1zM10 7a1 1 0 011-1h1a1 1 0 011 1v1a1 1 0 01-1 1h-1a1 1 0 01-1-1V7zM10 11a1 1 0 011-1h1a1 1 0 011 1v1a1 1 0 01-1 1h-1a1 1 0 01-1-1v-1zM13 10a1 1 0 011-1h1a1 1 0 011 1v1a1 1 0 01-1 1h-1a1 1 0 01-1-1v-1z" /></svg>
                </div>
                <span x-show="sidebarOpen" x-transition.opacity class="ml-3 font-bold text-lg tracking-tight">Core App</span>
            </div>

            <!-- Nav Links -->
            <nav class="flex-1 px-3 py-6 space-y-1 overflow-y-auto overflow-x-hidden">
                <a href="/dashboard" class="group flex items-center px-3 py-2 space-x-3 rounded-lg transition-all {{ Request::is('dashboard*') ? 'bg-zinc-900 border border-border-subtle text-white' : 'text-text-dim hover:text-white hover:bg-zinc-900/50' }}">
                    <svg class="w-5 h-5 {{ Request::is('dashboard*') ? 'text-brand-primary' : 'group-hover:text-white' }}" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2V6zM14 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2V6zM4 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2v-2zM14 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2v-2z"/></svg>
                    <span x-show="sidebarOpen" class="font-medium text-sm">Dashboard</span>
                </a>
                <a href="/events" class="group flex items-center px-3 py-2 space-x-3 rounded-lg transition-all {{ Request::is('events*') ? 'bg-zinc-900 border border-border-subtle text-white' : 'text-text-dim hover:text-white hover:bg-zinc-900/50' }}">
                    <svg class="w-5 h-5 {{ Request::is('events*') ? 'text-brand-primary' : 'group-hover:text-white' }}" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"/></svg>
                    <span x-show="sidebarOpen" class="font-medium text-sm">Management</span>
                </a>
                <a href="/scanner" class="group flex items-center px-3 py-2 space-x-3 rounded-lg transition-all {{ Request::is('scanner*') ? 'bg-zinc-900 border border-border-subtle text-white' : 'text-text-dim hover:text-white hover:bg-zinc-900/50' }}">
                    <svg class="w-5 h-5 {{ Request::is('scanner*') ? 'text-brand-primary' : 'group-hover:text-white' }}" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v1m6 11h2m-6 0h-2v4m0-11v3m0 0h.01M12 12h4.01M16 20h4M4 12h4m12 0h.01M5 8h2a1 1 0 001-1V5a1 1 0 00-1-1H5a1 1 0 00-1 1v2a1 1 0 001 1zm12 0h2a1 1 0 001-1V5a1 1 0 00-1-1h-2a1 1 0 00-1 1v2a1 1 0 001 1zM5 20h2a1 1 0 001-1v-2a1 1 0 00-1-1H5a1 1 0 00-1 1v2a1 1 0 001 1z" /></svg>
                    <span x-show="sidebarOpen" class="font-medium text-sm">Live Scanner</span>
                </a>
            </nav>

            <!-- Toggle Button -->
            <button @click="sidebarOpen = !sidebarOpen" class="h-10 border-t border-border-subtle flex items-center justify-center text-text-dim hover:text-white hover:bg-zinc-900 transition-colors">
                <svg :class="sidebarOpen ? '' : 'rotate-180'" class="w-4 h-4 transition-transform duration-300" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 19l-7-7 7-7m8 14l-7-7 7-7"/></svg>
            </button>
        </aside>

        <!-- Main Wrapper -->
        <div class="flex-1 flex flex-col min-w-0 bg-bg-main relative">
            
            <!-- Navbar -->
            <header class="h-16 border-b border-border-subtle bg-bg-main/80 backdrop-blur-md sticky top-0 z-20 flex items-center justify-between px-6 shrink-0">
                <div class="flex items-center space-x-4">
                    <button @click="mobileMenu = !mobileMenu" class="lg:hidden text-text-dim"><svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"/></svg></button>
                    <div class="h-8 w-px bg-border-subtle hidden lg:block"></div>
                    <div class="text-sm font-semibold tracking-wide uppercase text-text-dim">@yield('header')</div>
                </div>

                <div class="flex items-center space-x-6">
                    <!-- Config Trigger -->
                    <button @click="configOpen = true" class="text-text-dim hover:text-white transition-colors">
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37a1.724 1.724 0 002.572-1.065z"/><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/></svg>
                    </button>

                    <!-- Search Dummy -->
                    <div class="hidden md:flex items-center bg-zinc-900 border border-border-subtle rounded-md px-3 py-1.5 space-x-8 text-text-dim cursor-pointer hover:border-zinc-700 transition-colors">
                        <span class="text-xs">Quick search...</span>
                        <div class="flex items-center space-x-1">
                            <span class="px-1.5 py-0.5 rounded border border-border-subtle text-[10px] bg-zinc-800">⌘</span>
                            <span class="px-1.5 py-0.5 rounded border border-border-subtle text-[10px] bg-zinc-800">K</span>
                        </div>
                    </div>

                    <!-- User Circle -->
                    <div class="flex items-center space-x-3 pl-4 border-l border-border-subtle">
                         <div class="w-8 h-8 rounded-full bg-brand-primary flex items-center justify-center font-bold text-xs text-white">JD</div>
                         <button @click="$store.auth.setToken(''); window.location.reload()" 
                                 class="text-text-dim hover:text-brand-danger text-xs font-bold uppercase tracking-wider transition-colors">Out</button>
                    </div>
                </div>
            </header>

            <!-- Page Content -->
            <div class="flex-1 overflow-y-auto p-8 lg:p-12">
                @yield('content')
            </div>

            <!-- Configuration Modal -->
            <div x-show="configOpen" class="fixed inset-0 z-[100] flex items-center justify-center p-6 bg-black/80 backdrop-blur-sm" x-cloak>
                <div @click.away="configOpen = false" class="bento-card w-full max-w-md p-8 space-y-6">
                    <div>
                        <h3 class="text-xl font-bold">Session Configuration</h3>
                        <p class="text-xs text-text-description mt-1 text-balance">Configure your Admin credentials to enable live QR scanning and data synchronization.</p>
                    </div>
                    
                    <div class="space-y-4">
                        <div class="space-y-2">
                             <label class="text-[10px] font-bold uppercase tracking-widest text-text-description">Admin Bearer Token</label>
                             <input type="password" x-model="$store.auth.token" @input="$store.auth.setToken($event.target.value)" 
                                    class="w-full bg-zinc-900 border border-border-subtle rounded-md px-4 py-2 text-sm focus:outline-none focus:border-brand-primary" 
                                    placeholder="Paste token from /login response">
                        </div>
                        <div class="space-y-2">
                             <label class="text-[10px] font-bold uppercase tracking-widest text-text-description">Global API Key</label>
                             <input type="text" x-model="$store.auth.apiKey" @input="$store.auth.setApiKey($event.target.value)" 
                                    class="w-full bg-zinc-900 border border-border-subtle rounded-md px-4 py-2 text-sm focus:outline-none focus:border-brand-primary" 
                                    placeholder="APP_KEY">
                        </div>
                    </div>

                    <div class="pt-4">
                        <button @click="configOpen = false" class="w-full btn-primary italic">SAVE_AND_CLOSE</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Mobile Overly Menu -->
        <div x-show="mobileMenu" x-transition.opacity class="fixed inset-0 bg-black/60 z-40 lg:hidden" @click="mobileMenu = false"></div>
        <aside x-show="mobileMenu" x-transition:enter="transition ease-out duration-300 transform" x-transition:enter-start="-translate-x-full" x-transition:enter-end="translate-x-0"
               class="fixed inset-y-0 left-0 w-64 bg-bg-card z-50 lg:hidden border-r border-border-subtle">
             <!-- Same Nav Content as above -->
             <div class="h-16 flex items-center px-6 border-b border-border-subtle">
                <span class="font-bold text-lg">Core App</span>
             </div>
             <nav class="p-4 space-y-1">
                <!-- Mobile specific links if needed, otherwise same as desk -->
                <a href="/dashboard" class="flex items-center px-3 py-3 space-x-3 rounded-lg bg-zinc-900 text-white">Dashboard</a>
                <a href="/scanner" class="flex items-center px-3 py-3 space-x-3 rounded-lg text-text-dim">Scanner</a>
             </nav>
        </aside>

    </div>
</body>
</html>

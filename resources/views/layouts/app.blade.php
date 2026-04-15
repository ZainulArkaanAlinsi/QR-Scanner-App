<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}" class="h-full scroll-smooth">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="csrf-token" content="{{ csrf_token() }}">

    <title>@yield('title', 'Scanner Core')</title>

    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <!-- Styles & Scripts -->
    @vite(['resources/css/app.css', 'resources/js/app.js'])

    <!-- Alpine.js -->
    <script defer src="https://unpkg.com/alpinejs@3.x.x/dist/cdn.min.js"></script>

    <script>
        // Check for saved theme or default to dark
        const savedTheme = localStorage.getItem('theme') || 'dark';
        if (savedTheme === 'dark') {
            document.documentElement.classList.add('dark');
        } else {
            document.documentElement.classList.remove('dark');
        }

        document.addEventListener('alpine:init', () => {
            Alpine.store('theme', {
                mode: savedTheme,
                toggle() {
                    this.mode = this.mode === 'dark' ? 'light' : 'dark';
                    localStorage.setItem('theme', this.mode);
                    if (this.mode === 'dark') {
                        document.documentElement.classList.add('dark');
                    } else {
                        document.documentElement.classList.remove('dark');
                    }
                }
            });

            Alpine.store('auth', {
                token: localStorage.getItem('admin_token') || '',
                apiKey: localStorage.getItem('api_key') || 'K8vskiIaHsvc8NOvBpmAInxvq8YS6kuP',
                setToken(val) {
                    this.token = val;
                    localStorage.setItem('admin_token', val);
                },
                setApiKey(val) {
                    this.apiKey = val;
                    localStorage.setItem('api_key', val);
                },
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

<body class="h-full font-sans antialiased text-text-bright bg-bg-main selection:bg-emerald-500 selection:text-white">
    <!-- Background Decorative Elements -->
    <div class="fixed inset-0 overflow-hidden pointer-events-none -z-10">
        <div class="absolute -top-[10%] -left-[10%] w-[40%] h-[40%] bg-emerald-400/10 rounded-full blur-[120px]"></div>
        <div class="absolute top-[60%] -right-[10%] w-[35%] h-[40%] bg-emerald-500/5 rounded-full blur-[100px]"></div>
        <div class="absolute inset-0 opacity-[0.03] dark:opacity-[0.04]" style="background-image: radial-gradient(circle, currentColor 1px, transparent 1px); background-size: 24px 24px;"></div>
    </div>

    <div x-data="{ sidebarOpen: true, mobileMenu: false, configOpen: false }" class="flex h-screen overflow-hidden bg-transparent relative">

        <!-- Sidebar (Desktop) -->
        <aside :class="sidebarOpen ? 'w-64' : 'w-20'"
            class="hidden lg:flex flex-col h-full border-r border-border-subtle bg-bg-card/95 backdrop-blur-xl transition-all duration-300 ease-in-out z-30">

            <div class="h-16 flex items-center px-5 border-b border-border-subtle/30 overflow-hidden whitespace-nowrap">
                <div class="shrink-0 w-9 h-9 rounded-xl bg-gradient-to-br from-emerald-500 to-emerald-600 flex items-center justify-center shadow-lg shadow-emerald-500/25">
                    <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v1m6 11h2m-6 0h-2v4m0-11v3m0 0h.01M12 12h4.01M16 20h4M4 12h4m12 0h.01M5 8h2a1 1 0 001-1V5a1 1 0 00-1-1H5a1 1 0 00-1 1v2a1 1 0 001 1zm12 0h2a1 1 0 001-1V5a1 1 0 00-1-1h-2a1 1 0 00-1 1v2a1 1 0 001 1zM5 20h2a1 1 0 001-1v-2a1 1 0 00-1-1H5a1 1 0 00-1 1v2a1 1 0 001 1z" />
                    </svg>
                </div>
                <span x-show="sidebarOpen" x-transition.opacity class="ml-3 font-bold text-lg tracking-tight text-text-bright">ScanFlow</span>
            </div>

            <!-- Nav Links -->
            <nav class="flex-1 px-3 py-5 space-y-1.5 overflow-y-auto overflow-x-hidden">
                <a href="/dashboard"
                    class="group flex items-center px-3 py-3 rounded-xl transition-all duration-200 {{ Request::is('dashboard*') ? 'bg-emerald-50 dark:bg-emerald-500/10 text-emerald-600 dark:text-emerald-400' : 'text-text-dim hover:text-text-bright hover:bg-bg-elevated' }}">
                    <svg class="w-5 h-5 {{ Request::is('dashboard*') ? 'text-emerald-600 dark:text-emerald-400' : 'text-text-description group-hover:text-text-bright' }}"
                        fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2V6zM14 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2V6zM4 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2v-2zM14 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2v-2z" />
                    </svg>
                    <span x-show="sidebarOpen" class="ml-3 text-sm font-medium">Dashboard</span>
                </a>
                <a href="/events"
                    class="group flex items-center px-3 py-3 rounded-xl transition-all duration-200 {{ Request::is('events*') ? 'bg-emerald-50 dark:bg-emerald-500/10 text-emerald-600 dark:text-emerald-400' : 'text-text-dim hover:text-text-bright hover:bg-bg-elevated' }}">
                    <svg class="w-5 h-5 {{ Request::is('events*') ? 'text-emerald-600 dark:text-emerald-400' : 'text-text-description group-hover:text-text-bright' }}"
                        fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10" />
                    </svg>
                    <span x-show="sidebarOpen" class="ml-3 text-sm font-medium">Events</span>
                </a>
                <a href="/scanner"
                    class="group flex items-center px-3 py-3 rounded-xl transition-all duration-200 {{ Request::is('scanner*') ? 'bg-emerald-50 dark:bg-emerald-500/10 text-emerald-600 dark:text-emerald-400' : 'text-text-dim hover:text-text-bright hover:bg-bg-elevated' }}">
                    <svg class="w-5 h-5 {{ Request::is('scanner*') ? 'text-emerald-600 dark:text-emerald-400' : 'text-text-description group-hover:text-text-bright' }}"
                        fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v1m6 11h2m-6 0h-2v4m0-11v3m0 0h.01M12 12h4.01M16 20h4M4 12h4m12 0h.01M5 8h2a1 1 0 001-1V5a1 1 0 00-1-1H5a1 1 0 00-1 1v2a1 1 0 001 1zm12 0h2a1 1 0 001-1V5a1 1 0 00-1-1h-2a1 1 0 00-1 1v2a1 1 0 001 1zM5 20h2a1 1 0 001-1v-2a1 1 0 00-1-1H5a1 1 0 00-1 1v2a1 1 0 001 1z" />
                    </svg>
                    <span x-show="sidebarOpen" class="ml-3 text-sm font-medium">Live Scan</span>
                </a>
            </nav>

            <!-- Toggle Button -->
            <button @click="sidebarOpen = !sidebarOpen"
                class="h-14 border-t border-border-subtle/30 flex items-center justify-center text-text-dim hover:text-text-bright hover:bg-bg-elevated transition-colors">
                <svg :class="sidebarOpen ? '' : 'rotate-180'" class="w-5 h-5 transition-transform duration-300"
                    fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 19l-7-7 7-7m8 14l-7-7 7-7" />
                </svg>
            </button>
        </aside>

        <!-- Main Wrapper -->
        <div class="flex-1 flex flex-col min-w-0 bg-bg-main relative">

            <!-- Navbar -->
            <header
                class="h-16 border-b border-border-subtle/30 bg-bg-card/80 backdrop-blur-md sticky top-0 z-20 flex items-center justify-between px-4 lg:px-6 shrink-0">
                <div class="flex items-center space-x-4">
                    <button @click="mobileMenu = !mobileMenu" class="lg:hidden p-2 -ml-2 text-text-dim hover:text-text-bright hover:bg-bg-elevated rounded-xl transition-colors">
                        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
                        </svg>
                    </button>
                    <div class="block lg:hidden">
                        <span class="font-bold text-xl tracking-tight text-text-bright">ScanFlow</span>
                    </div>
                    <div class="hidden lg:flex items-center space-x-2 px-3 py-1.5 bg-emerald-50 dark:bg-emerald-500/10 rounded-full">
                        <span class="w-2 h-2 rounded-full bg-emerald-500 animate-pulse"></span>
                        <h2 class="text-xs font-semibold text-emerald-600 dark:text-emerald-400">System Active</h2>
                    </div>
                </div>

                <div class="flex items-center space-x-3">
                    <!-- Theme Toggle -->
                    <div class="flex items-center bg-bg-elevated rounded-xl p-1 border border-border-subtle">
                        <button @click="$store.theme.toggle()" 
                                :class="$store.theme.mode === 'light' ? 'bg-white dark:bg-bg-card text-emerald-600 shadow-sm' : 'text-text-dim'"
                                class="p-2 rounded-lg transition-all duration-200">
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 3v1m0 16v1m9-9h-1M4 12H3m15.364 6.364l-.707-.707M6.343 6.343l-.707-.707m12.728 0l-.707.707M6.343 17.657l-.707.707M16 12a4 4 0 11-8 0 4 4 0 018 0z" />
                            </svg>
                        </button>
                        <button @click="$store.theme.toggle()" 
                                :class="$store.theme.mode === 'dark' ? 'bg-bg-card dark:bg-bg-card text-emerald-500 shadow-sm' : 'text-text-dim'"
                                class="p-2 rounded-lg transition-all duration-200">
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20.354 15.354A9 9 0 018.646 3.646 9.003 9.003 0 0012 21a9.003 9.003 0 008.354-5.646z" />
                            </svg>
                        </button>
                    </div>

                    <!-- User Information -->
                    <div class="flex items-center space-x-3 pl-2">
                        <div class="text-right hidden sm:block">
                            <p class="text-sm font-semibold text-text-bright leading-none capitalize">Zainul Arkaan</p>
                            <p class="text-xs text-text-dim mt-0.5">Administrator</p>
                        </div>
                        <div class="w-10 h-10 rounded-xl bg-gradient-to-br from-emerald-400 to-emerald-600 flex items-center justify-center text-white font-bold text-sm shadow-lg shadow-emerald-500/20 overflow-hidden">
                            <span>ZA</span>
                        </div>
                    </div>
                </div>
            </header>

            <!-- Page Content -->
            <main class="flex-1 overflow-y-auto p-4 lg:p-8">
                @yield('content')
            </main>

            <!-- Configuration Modal -->
            <div x-show="configOpen"
                class="fixed inset-0 z-[100] flex items-center justify-center p-4"
                x-transition:enter="transition ease-out duration-300"
                x-transition:enter-start="opacity-0"
                x-transition:enter-end="opacity-100"
                x-cloak>
                <div class="absolute inset-0 bg-bg-main/60 backdrop-blur-sm" @click="configOpen = false"></div>
                <div class="bento-card w-full max-w-md p-6 lg:p-8 space-y-6 shadow-2xl relative z-10">
                    <div>
                        <h3 class="text-lg font-bold text-text-bright">System Settings</h3>
                        <p class="text-xs text-text-dim mt-1">Configure your authentication keys and tokens.</p>
                    </div>

                    <div class="space-y-4">
                        <div class="space-y-2">
                            <label class="technical-label">Admin Bearer Token</label>
                            <input type="password" x-model="$store.auth.token"
                                @input="$store.auth.setToken($event.target.value)"
                                class="w-full bg-bg-elevated border border-border-subtle rounded-xl px-4 py-2.5 text-sm text-text-bright focus:outline-none focus:ring-2 focus:ring-brand-primary/20 focus:border-brand-primary transition-all"
                                placeholder="Bearer token...">
                        </div>
                        <div class="space-y-2">
                            <label class="technical-label">Global API Key</label>
                            <input type="text" x-model="$store.auth.apiKey"
                                @input="$store.auth.setApiKey($event.target.value)"
                                class="w-full bg-bg-elevated border border-border-subtle rounded-xl px-4 py-2.5 text-sm text-text-bright focus:outline-none focus:ring-2 focus:ring-brand-primary/20 focus:border-brand-primary transition-all"
                                placeholder="X-Api-Key">
                        </div>
                    </div>

                    <div class="pt-2">
                        <button @click="configOpen = false" class="w-full btn-primary">Save Changes</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Mobile Sidebar Overlay -->
        <div x-show="mobileMenu" 
             class="fixed inset-0 bg-black/60 z-[100] lg:hidden backdrop-blur-sm"
             x-transition:enter="transition ease-out duration-300"
             x-transition:enter-start="opacity-0"
             x-transition:enter-end="opacity-100"
             @click="mobileMenu = false" 
             x-cloak></div>
        
        <aside x-show="mobileMenu" 
            x-transition:enter="transition ease-out duration-300 transform"
            x-transition:enter-start="-translate-x-full" 
            x-transition:enter-end="translate-x-0"
            x-transition:leave="transition ease-in duration-200 transform"
            x-transition:leave-start="translate-x-0"
            x-transition:leave-end="-translate-x-full"
            class="fixed inset-y-0 left-0 w-[280px] bg-bg-card z-[101] lg:hidden border-r border-border-subtle shadow-2xl flex flex-col"
            x-cloak>
            
            <div class="flex items-center justify-between h-16 px-5 border-b border-border-subtle/30">
                <div class="flex items-center space-x-3">
                    <div class="w-9 h-9 rounded-xl bg-gradient-to-br from-emerald-500 to-emerald-600 flex items-center justify-center shadow-lg shadow-emerald-500/25">
                        <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v1m6 11h2m-6 0h-2v4m0-11v3m0 0h.01M12 12h4.01M16 20h4M4 12h4m12 0h.01M5 8h2a1 1 0 001-1V5a1 1 0 00-1-1H5a1 1 0 00-1 1v2a1 1 0 001 1zm12 0h2a1 1 0 001-1V5a1 1 0 00-1-1h-2a1 1 0 00-1 1v2a1 1 0 001 1zM5 20h2a1 1 0 001-1v-2a1 1 0 00-1-1H5a1 1 0 00-1 1v2a1 1 0 001 1z" />
                        </svg>
                    </div>
                    <span class="font-bold text-lg tracking-tight">ScanFlow</span>
                </div>
                <button @click="mobileMenu = false" class="p-2 text-text-dim hover:text-text-bright hover:bg-bg-elevated rounded-xl transition-colors">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                    </svg>
                </button>
            </div>

            <nav class="flex-1 px-4 py-6 space-y-1">
                <a href="/dashboard" @click="mobileMenu = false"
                    class="flex items-center px-4 py-3.5 rounded-xl transition-all {{ Request::is('dashboard*') ? 'bg-emerald-50 dark:bg-emerald-500/10 text-emerald-600 dark:text-emerald-400 font-medium' : 'text-text-dim hover:text-text-bright hover:bg-bg-elevated' }}">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2V6zM14 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2V6zM4 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2v-2zM14 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2v-2z" />
                    </svg>
                    <span class="ml-3">Dashboard</span>
                </a>
                <a href="/events" @click="mobileMenu = false"
                    class="flex items-center px-4 py-3.5 rounded-xl transition-all {{ Request::is('events*') ? 'bg-emerald-50 dark:bg-emerald-500/10 text-emerald-600 dark:text-emerald-400 font-medium' : 'text-text-dim hover:text-text-bright hover:bg-bg-elevated' }}">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10" />
                    </svg>
                    <span class="ml-3">Events</span>
                </a>
                <a href="/scanner" @click="mobileMenu = false"
                    class="flex items-center px-4 py-3.5 rounded-xl transition-all {{ Request::is('scanner*') ? 'bg-emerald-50 dark:bg-emerald-500/10 text-emerald-600 dark:text-emerald-400 font-medium' : 'text-text-dim hover:text-text-bright hover:bg-bg-elevated' }}">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v1m6 11h2m-6 0h-2v4m0-11v3m0 0h.01M12 12h4.01M16 20h4M4 12h4m12 0h.01M5 8h2a1 1 0 001-1V5a1 1 0 00-1-1H5a1 1 0 00-1 1v2a1 1 0 001 1zm12 0h2a1 1 0 001-1V5a1 1 0 00-1-1h-2a1 1 0 00-1 1v2a1 1 0 001 1zM5 20h2a1 1 0 001-1v-2a1 1 0 00-1-1H5a1 1 0 00-1 1v2a1 1 0 001 1z" />
                    </svg>
                    <span class="ml-3">Live Scanner</span>
                </a>
            </nav>

            <div class="p-4 border-t border-border-subtle/30">
                <div class="flex items-center space-x-3 p-3 bg-bg-elevated rounded-xl">
                    <div class="w-10 h-10 rounded-xl bg-gradient-to-br from-emerald-400 to-emerald-600 flex items-center justify-center text-white font-bold text-sm">
                        <span>ZA</span>
                    </div>
                    <div>
                        <p class="text-sm font-semibold text-text-bright">Zainul Arkaan</p>
                        <p class="text-xs text-text-dim">Administrator</p>
                    </div>
                </div>
            </div>
        </aside>

    </div>
</body>

</html>

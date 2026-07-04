<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Map" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TechMart Online — Enterprise Performance Dashboard</title>
    <meta name="description" content="TechMart Online enterprise performance dashboard for monitoring orders, inventory, and system health.">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://maxst.icons8.com/vue-static/landings/line-awesome/line-awesome/1.3.0/css/line-awesome.min.css">
    <style>
        :root {
            --green-900: #14532d;
            --green-800: #166534;
            --green-700: #15803d;
            --green-600: #16a34a;
            --green-500: #22c55e;
            --green-400: #4ade80;
            --green-300: #86efac;
            --green-200: #bbf7d0;
            --green-100: #dcfce7;
            --green-50:  #f0fdf4;
            --gray-950: #0a0a0a;
            --gray-900: #171717;
            --gray-800: #262626;
            --gray-700: #404040;
            --gray-600: #525252;
            --gray-500: #737373;
            --gray-400: #a3a3a3;
            --gray-300: #d4d4d4;
            --gray-200: #e5e5e5;
            --gray-100: #f5f5f5;
            --gray-50:  #fafafa;
            --white:    #ffffff;
            --amber-500: #f59e0b;
            --red-500:   #ef4444;
            --blue-500:  #3b82f6;
            --purple-500:#a855f7;
            --bg-main:    #f3f4f6;
            --bg-sidebar: var(--white);
            --bg-card:    var(--white);
            --border:     #e5e7eb;
            --shadow-sm:  0 1px 2px rgba(0,0,0,0.05);
            --shadow-md:  0 4px 6px -1px rgba(0,0,0,0.07), 0 2px 4px -1px rgba(0,0,0,0.04);
            --shadow-lg:  0 10px 15px -3px rgba(0,0,0,0.08), 0 4px 6px -2px rgba(0,0,0,0.04);
            --radius-sm: 8px;
            --radius-md: 12px;
            --radius-lg: 16px;
            --radius-xl: 20px;
            --radius-full: 9999px;
        }
        * { margin:0; padding:0; box-sizing:border-box; }
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background: var(--bg-main);
            color: var(--gray-900);
            display: flex;
            min-height: 100vh;
        }

        /* Sidebar */
        .sidebar {
            width: 240px; background: var(--bg-sidebar); border-right: 1px solid var(--border);
            display: flex; flex-direction: column; padding: 24px 16px;
            position: fixed; top:0; left:0; bottom:0; z-index:100;
        }
        .sidebar-logo { display:flex; align-items:center; gap:10px; padding:0 8px; margin-bottom:32px; }
        .sidebar-logo .logo-icon {
            width:36px; height:36px; background:var(--green-600); border-radius:var(--radius-sm);
            display:flex; align-items:center; justify-content:center; color:var(--white);
            font-size:18px; font-weight:800;
        }
        .sidebar-logo .logo-text { font-size:18px; font-weight:700; color:var(--gray-900); }
        .sidebar-section { margin-bottom:24px; }
        .sidebar-section-label {
            font-size:11px; font-weight:600; text-transform:uppercase; letter-spacing:0.8px;
            color:var(--gray-400); padding:0 12px; margin-bottom:8px;
        }
        .sidebar-nav { list-style:none; }
        .sidebar-nav li a {
            display:flex; align-items:center; gap:12px; padding:10px 12px; border-radius:var(--radius-sm);
            text-decoration:none; color:var(--gray-600); font-size:14px; font-weight:500; transition:all 0.2s;
        }
        .sidebar-nav li a:hover { background:var(--green-50); color:var(--green-700); }
        .sidebar-nav li a.active { background:var(--green-50); color:var(--green-700); font-weight:600; }
        .sidebar-nav li a .nav-icon { width:20px; height:20px; display:flex; align-items:center; justify-content:center; font-size:16px; }
        .sidebar-nav li a .badge-count {
            margin-left:auto; background:var(--green-600); color:var(--white);
            font-size:11px; font-weight:600; padding:2px 8px; border-radius:var(--radius-full); min-width:22px; text-align:center;
        }
        .sidebar-bottom {
            margin-top:auto; padding:16px; background:linear-gradient(135deg, var(--green-700), var(--green-900));
            border-radius:var(--radius-lg); color:var(--white); text-align:center;
        }
        .sidebar-bottom h4 { font-size:14px; font-weight:600; margin-bottom:4px; }
        .sidebar-bottom p { font-size:12px; opacity:0.8; margin-bottom:12px; }
        .sidebar-bottom .cta-btn {
            display:inline-block; padding:8px 20px; background:var(--green-400); color:var(--green-900);
            font-weight:600; font-size:13px; border-radius:var(--radius-full); text-decoration:none; transition:background 0.2s;
        }
        .sidebar-bottom .cta-btn:hover { background:var(--green-300); }

        /* Main */
        .main { margin-left:240px; flex:1; min-height:100vh; }

        /* Topbar */
        .topbar {
            display:flex; align-items:center; justify-content:space-between;
            padding:16px 32px; background:var(--white); border-bottom:1px solid var(--border);
            position:sticky; top:0; z-index:50;
        }
        .search-box {
            display:flex; align-items:center; gap:10px; background:var(--gray-100);
            border:1px solid var(--border); border-radius:var(--radius-sm); padding:8px 16px; width:320px;
        }
        .search-box:focus-within { border-color:var(--green-500); box-shadow:0 0 0 3px rgba(34,197,94,0.1); }
        .search-box input { border:none; background:transparent; outline:none; font-size:14px; color:var(--gray-700); width:100%; font-family:inherit; }
        .search-box .search-icon { color:var(--gray-400); font-size:14px; }
        .search-box .shortcut {
            font-size:11px; color:var(--gray-400); background:var(--white); border:1px solid var(--border);
            border-radius:4px; padding:2px 6px; font-weight:500; white-space:nowrap;
        }
        .topbar-right { display:flex; align-items:center; gap:16px; }
        .topbar-icon {
            width:38px; height:38px; border-radius:var(--radius-sm); border:1px solid var(--border);
            display:flex; align-items:center; justify-content:center; color:var(--gray-600);
            font-size:16px; cursor:pointer; transition:all 0.2s; background:var(--white); position:relative;
        }
        .topbar-icon:hover { background:var(--green-50); border-color:var(--green-200); color:var(--green-700); }
        .topbar-icon .notif-dot {
            position:absolute; top:6px; right:6px; width:8px; height:8px;
            background:var(--red-500); border-radius:50%; border:2px solid var(--white);
        }
        .user-profile { display:flex; align-items:center; gap:10px; cursor:pointer; padding:4px 8px; border-radius:var(--radius-sm); transition:background 0.2s; }
        .user-profile:hover { background:var(--gray-50); }
        .user-avatar {
            width:36px; height:36px; border-radius:50%; background:linear-gradient(135deg, var(--green-400), var(--green-700));
            display:flex; align-items:center; justify-content:center; color:var(--white); font-weight:700; font-size:14px;
        }
        .user-info { line-height:1.3; }
        .user-info .user-name { font-size:13px; font-weight:600; color:var(--gray-900); }
        .user-info .user-role { font-size:11px; color:var(--gray-500); }

        /* Dashboard */
        .dashboard-content { padding:28px 32px; }
        .page-header { display:flex; align-items:flex-start; justify-content:space-between; margin-bottom:28px; }
        .page-header h1 { font-size:28px; font-weight:700; color:var(--gray-900); letter-spacing:-0.5px; }
        .page-header .subtitle { font-size:14px; color:var(--gray-500); margin-top:4px; }
        .header-actions { display:flex; gap:12px; }
        .btn {
            display:inline-flex; align-items:center; gap:8px; padding:10px 20px; border-radius:var(--radius-sm);
            font-size:14px; font-weight:600; cursor:pointer; transition:all 0.2s; border:none; font-family:inherit;
        }
        .btn-primary { background:var(--green-700); color:var(--white); }
        .btn-primary:hover { background:var(--green-800); box-shadow:var(--shadow-md); }
        .btn-outline { background:var(--white); color:var(--gray-700); border:1px solid var(--border); }
        .btn-outline:hover { background:var(--gray-50); border-color:var(--gray-300); }

        /* Stat Cards */
        .stats-row { display:grid; grid-template-columns:repeat(4,1fr); gap:20px; margin-bottom:24px; }
        .stat-card {
            background:var(--bg-card); border:1px solid var(--border); border-radius:var(--radius-lg);
            padding:20px 24px; transition:all 0.3s ease; position:relative; overflow:hidden;
        }
        .stat-card:hover { box-shadow:var(--shadow-lg); transform:translateY(-2px); }
        .stat-card.highlight { background:linear-gradient(135deg, var(--green-600), var(--green-800)); color:var(--white); border:none; }
        .stat-card.highlight .stat-label { color:var(--green-200); }
        .stat-card.highlight .stat-value { color:var(--white); }
        .stat-card.highlight .stat-trend { color:var(--green-200); }
        .stat-card-header { display:flex; justify-content:space-between; align-items:flex-start; margin-bottom:12px; }
        .stat-label { font-size:13px; font-weight:600; color:var(--gray-500); }
        .stat-arrow {
            width:28px; height:28px; border-radius:50%; display:flex; align-items:center;
            justify-content:center; font-size:12px; cursor:pointer; transition:all 0.2s;
        }
        .stat-card:not(.highlight) .stat-arrow { background:var(--gray-100); color:var(--gray-600); }
        .stat-card.highlight .stat-arrow { background:rgba(255,255,255,0.2); color:var(--white); }
        .stat-value { font-size:36px; font-weight:800; color:var(--gray-900); line-height:1.1; letter-spacing:-1px; margin-bottom:6px; }
        .stat-trend { font-size:12px; font-weight:500; color:var(--green-600); display:flex; align-items:center; gap:4px; }
        .stat-trend .dot { width:6px; height:6px; border-radius:50%; background:var(--green-500); }
        .stat-card.highlight .stat-trend .dot { background:var(--green-300); }

        /* Grid layouts */
        .grid-3col { display:grid; grid-template-columns:1fr 1fr 1fr; gap:20px; margin-bottom:24px; }
        .card {
            background:var(--bg-card); border:1px solid var(--border); border-radius:var(--radius-lg);
            padding:24px; transition:all 0.3s ease;
        }
        .card:hover { box-shadow:var(--shadow-lg); }
        .card-header { display:flex; align-items:center; justify-content:space-between; margin-bottom:20px; }
        .card-title { font-size:16px; font-weight:700; color:var(--gray-900); }
        .card-action {
            font-size:12px; font-weight:600; color:var(--green-600); text-decoration:none;
            padding:4px 12px; border:1px solid var(--green-200); border-radius:var(--radius-full); transition:all 0.2s;
        }
        .card-action:hover { background:var(--green-50); border-color:var(--green-400); }

        /* Metrics rows */
        .metric-row { display:flex; justify-content:space-between; align-items:center; padding:10px 16px; background:var(--gray-50); border-radius:var(--radius-md); margin-bottom:8px; transition:background 0.2s; }
        .metric-row:hover { background:var(--green-50); }
        .metric-row:last-child { margin-bottom:0; }
        .metric-label { font-size:13px; font-weight:500; color:var(--gray-600); }
        .metric-value { font-size:14px; font-weight:700; color:var(--green-700); font-variant-numeric:tabular-nums; }

        /* Status items */
        .status-item {
            display:flex; align-items:center; justify-content:space-between; padding:12px 16px;
            background:var(--gray-50); border-radius:var(--radius-md); transition:background 0.2s;
        }
        .status-item:hover { background:var(--green-50); }
        .status-item-left { display:flex; align-items:center; gap:12px; }
        .status-dot { width:10px; height:10px; border-radius:50%; }
        .status-dot.online { background:var(--green-500); box-shadow:0 0 8px rgba(34,197,94,0.4); }
        .status-item-label { font-size:13px; font-weight:500; color:var(--gray-700); }
        .status-item-value { font-size:12px; font-weight:600; color:var(--gray-500); }

        /* Meeting / System card */
        .meeting-card {
            background:var(--green-50); border:1px solid var(--green-200); border-radius:var(--radius-md); padding:16px;
        }
        .meeting-title { font-size:18px; font-weight:700; color:var(--gray-900); margin-bottom:4px; }
        .meeting-time { font-size:13px; color:var(--gray-500); margin-bottom:14px; }
        .meeting-btn {
            display:inline-flex; align-items:center; gap:8px; padding:10px 20px;
            background:var(--green-700); color:var(--white); border:none; border-radius:var(--radius-sm);
            font-size:13px; font-weight:600; cursor:pointer; font-family:inherit; transition:background 0.2s;
        }
        .meeting-btn:hover { background:var(--green-800); }

        /* Component list */
        .component-list { display:flex; flex-direction:column; gap:12px; max-height:260px; overflow-y:auto; }
        .component-list::-webkit-scrollbar { width:4px; }
        .component-list::-webkit-scrollbar-track { background:transparent; }
        .component-list::-webkit-scrollbar-thumb { background:var(--gray-200); border-radius:2px; }
        .component-item { display:flex; align-items:center; gap:12px; padding:10px 0; border-bottom:1px solid var(--gray-100); transition:all 0.2s; }
        .component-item:last-child { border-bottom:none; }
        .component-icon {
            width:32px; height:32px; border-radius:var(--radius-sm); display:flex; align-items:center;
            justify-content:center; font-size:14px; font-weight:700; flex-shrink:0;
        }
        .component-icon.singleton { background:var(--green-100); color:var(--green-700); }
        .component-icon.stateless { background:#dbeafe; color:var(--blue-500); }
        .component-icon.stateful  { background:#f3e8ff; color:var(--purple-500); }
        .component-icon.mdb       { background:#fef3c7; color:var(--amber-500); }
        .component-info { flex:1; min-width:0; }
        .component-name { font-size:13px; font-weight:600; color:var(--gray-900); white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
        .component-desc { font-size:11px; color:var(--gray-400); white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }

        /* Bottom row */
        .grid-bottom { display:grid; grid-template-columns:1fr 1fr 1fr; gap:20px; }

        /* Config card */
        .config-card .config-item { display:flex; justify-content:space-between; align-items:center; padding:10px 16px; background:var(--gray-50); border-radius:var(--radius-md); margin-bottom:8px; transition:background 0.2s; }
        .config-card .config-item:hover { background:var(--green-50); }
        .config-card .config-key { font-size:12px; font-weight:500; color:var(--gray-500); font-family:'Courier New',monospace; }
        .config-card .config-val { font-size:13px; font-weight:700; color:var(--gray-800); }

        /* Cache card */
        .cache-stat { text-align:center; padding:20px; }
        .cache-stat .cache-big { font-size:48px; font-weight:800; color:var(--green-600); letter-spacing:-2px; }
        .cache-stat .cache-label { font-size:13px; color:var(--gray-500); margin-top:4px; }
        .cache-details { display:grid; grid-template-columns:1fr 1fr; gap:8px; margin-top:16px; }
        .cache-detail-item { text-align:center; padding:12px; background:var(--gray-50); border-radius:var(--radius-md); }
        .cache-detail-item .cdv { font-size:18px; font-weight:700; color:var(--gray-900); }
        .cache-detail-item .cdl { font-size:11px; color:var(--gray-400); margin-top:2px; }

        /* Uptime card */
        .uptime-card {
            background:linear-gradient(145deg, var(--green-800), #052e16); border:none; color:var(--white);
            display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center;
            min-height:280px; position:relative; overflow:hidden;
        }
        .uptime-card::before {
            content:''; position:absolute; inset:0;
            background:url("data:image/svg+xml,%3Csvg width='60' height='60' viewBox='0 0 60 60' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='none' fill-rule='evenodd'%3E%3Cg fill='%23ffffff' fill-opacity='0.03'%3E%3Cpath d='M36 34v-4h-2v4h-4v2h4v4h2v-4h4v-2h-4zm0-30V0h-2v4h-4v2h4v4h2V6h4V4h-4zM6 34v-4H4v4H0v2h4v4h2v-4h4v-2H6zM6 4V0H4v4H0v2h4v4h2V6h4V4H6z'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E");
            opacity:0.5;
        }
        .uptime-label { font-size:14px; font-weight:600; color:var(--green-300); margin-bottom:12px; position:relative; z-index:1; }
        .uptime-time {
            font-size:42px; font-weight:800; letter-spacing:3px; font-variant-numeric:tabular-nums;
            position:relative; z-index:1; text-shadow:0 2px 20px rgba(0,0,0,0.3);
        }
        .uptime-sub { font-size:12px; color:var(--green-300); margin-top:8px; position:relative; z-index:1; }
        .uptime-buttons { display:flex; gap:16px; margin-top:24px; position:relative; z-index:1; }
        .uptime-btn {
            width:48px; height:48px; border-radius:50%; border:none; display:flex; align-items:center;
            justify-content:center; font-size:18px; cursor:pointer; transition:all 0.2s;
        }
        .uptime-btn.refresh-btn { background:var(--green-400); color:var(--green-900); }
        .uptime-btn.stop-btn { background:var(--red-500); color:var(--white); }
        .uptime-btn:hover { transform:scale(1.1); box-shadow:0 4px 15px rgba(0,0,0,0.3); }

        /* Animations */
        @keyframes fadeInUp { from{opacity:0;transform:translateY(20px)} to{opacity:1;transform:translateY(0)} }
        .animate-in { animation:fadeInUp 0.6s ease-out both; }
        .animate-in-1{animation-delay:0.05s} .animate-in-2{animation-delay:0.1s}
        .animate-in-3{animation-delay:0.15s} .animate-in-4{animation-delay:0.2s}
        .animate-in-5{animation-delay:0.25s}

        /* Responsive */
        @media(max-width:1200px){.grid-3col,.grid-bottom{grid-template-columns:1fr 1fr}}
        @media(max-width:900px){.sidebar{display:none}.main{margin-left:0}.stats-row{grid-template-columns:repeat(2,1fr)}.grid-3col,.grid-bottom{grid-template-columns:1fr}}
        @media(max-width:600px){.stats-row{grid-template-columns:1fr}.dashboard-content{padding:16px}.topbar{padding:12px 16px}}
    </style>
</head>
<body>
<%@ page import="java.util.List" %>
<%@ page import="com.techmart.service.Product" %>
<%
    Map<String, Long> metrics = (Map<String, Long>) request.getAttribute("metrics");
    Map<String, String> configMap = (Map<String, String>) request.getAttribute("config");
    String uptime = (String) request.getAttribute("uptime");
    String healthSummary = (String) request.getAttribute("healthSummary");
    String cacheStats = (String) request.getAttribute("cacheStats");

    // Extract metric values safely
    long totalOrders = metrics != null ? metrics.getOrDefault("total.orders.processed", 0L) : 0;
    long totalCheckouts = metrics != null ? metrics.getOrDefault("total.checkouts.completed", 0L) : 0;
    long totalSearches = metrics != null ? metrics.getOrDefault("total.search.queries", 0L) : 0;
    long totalJms = metrics != null ? metrics.getOrDefault("total.jms.messages.sent", 0L) : 0;
    long totalAsync = metrics != null ? metrics.getOrDefault("total.async.tasks.completed", 0L) : 0;
    long totalCache = metrics != null ? metrics.getOrDefault("total.cache.refreshes", 0L) : 0;

    String env = configMap != null ? configMap.getOrDefault("platform.environment", "UNKNOWN") : "UNKNOWN";
%>


    <aside class="sidebar">
        <div class="sidebar-logo">
            <div class="logo-icon">E</div>
            <span class="logo-text">TechMart</span>
        </div>
        <div class="sidebar-section">
            <div class="sidebar-section-label">Menu</div>
            <ul class="sidebar-nav">
                <li><a href="/TechMart/metrics" class="active"><span class="nav-icon"><i class="las la-chart-bar"></i></span> Dashboard</a></li>
                <li><a href="#"><span class="nav-icon"><i class="las la-box"></i></span> Orders <span class="badge-count"><%= totalOrders %></span></a></li>
                <li><a href="#"><span class="nav-icon"><i class="las la-archive"></i></span> Inventory</a></li>
                <li><a href="#"><span class="nav-icon"><i class="las la-chart-line"></i></span> Analytics</a></li>
                <li><a href="#"><span class="nav-icon"><i class="las la-cog"></i></span> EJB Beans</a></li>
            </ul>
        </div>
        <div class="sidebar-section">
            <div class="sidebar-section-label">General</div>
            <ul class="sidebar-nav">
                <li><a href="#"><span class="nav-icon"><i class="las la-wrench"></i></span> Settings</a></li>
                <li><a href="#"><span class="nav-icon"><i class="las la-heartbeat"></i></span> Health</a></li>
                <li><a href="#"><span class="nav-icon"><i class="las la-file-alt"></i></span> Logs</a></li>
            </ul>
        </div>
        <div class="sidebar-bottom">
            <h4>Payara Server 6</h4>
            <p>Enterprise runtime ready</p>
            <a href="http://localhost:4848" class="cta-btn">Admin Console</a>
        </div>
    </aside>


    <div class="main">

        <div class="topbar">
            <div class="search-box">
                <span class="search-icon"><i class="las la-search"></i></span>
                <input type="text" placeholder="Search products, orders, beans...">
                <span class="shortcut">⌘ F</span>
            </div>
            <div class="topbar-right">
                <div class="topbar-icon" title="Messages"><i class="las la-envelope"></i></div>
                <div class="topbar-icon" title="Notifications"><i class="las la-bell"></i><span class="notif-dot"></span></div>
                <div class="user-profile">
                    <div class="user-avatar">AD</div>
                    <div class="user-info">
                        <div class="user-name">Admin</div>
                        <div class="user-role">admin@techmart.lk</div>
                    </div>
                </div>
            </div>
        </div>


        <div class="dashboard-content">
            <div class="page-header animate-in animate-in-1">
                <div>
                    <h1>Dashboard</h1>
                    <p class="subtitle">Monitor, analyze, and optimize your TechMart enterprise operations.</p>
                </div>
                <div class="header-actions">
                    <button class="btn btn-primary" onclick="window.location.reload()"><i class="las la-sync"></i> Refresh Data</button>
                    <button class="btn btn-outline">Export Data</button>
                </div>
            </div>

          
            <div class="stats-row animate-in animate-in-2">
                <div class="stat-card highlight">
                    <div class="stat-card-header">
                        <span class="stat-label">Total Orders</span>
                        <div class="stat-arrow"><i class="las la-arrow-right"></i></div>
                    </div>
                    <div class="stat-value"><%= totalOrders %></div>
                    <div class="stat-trend"><span class="dot"></span> Live from AppConfigBean</div>
                </div>
                <div class="stat-card">
                    <div class="stat-card-header">
                        <span class="stat-label">Total Checkouts</span>
                        <div class="stat-arrow"><i class="las la-arrow-right"></i></div>
                    </div>
                    <div class="stat-value"><%= totalCheckouts %></div>
                    <div class="stat-trend"><span class="dot"></span> CheckOutService (SLSB)</div>
                </div>
                <div class="stat-card">
                    <div class="stat-card-header">
                        <span class="stat-label">Search Queries</span>
                        <div class="stat-arrow"><i class="las la-arrow-right"></i></div>
                    </div>
                    <div class="stat-value"><%= totalSearches %></div>
                    <div class="stat-trend"><span class="dot"></span> ProductSearchService</div>
                </div>
                <div class="stat-card">
                    <div class="stat-card-header">
                        <span class="stat-label">JMS Messages</span>
                        <div class="stat-arrow"><i class="las la-arrow-right"></i></div>
                    </div>
                    <div class="stat-value"><%= totalJms %></div>
                    <div class="stat-trend" style="color:var(--amber-500)"><span class="dot" style="background:var(--amber-500)"></span> MDB Pipeline</div>
                </div>
            </div>

            
            <div class="grid-3col animate-in animate-in-3">
                
    
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title"><i class="las la-search"></i> Product Discovery</h3>
                    </div>
                    <form method="GET" action="dashboard" style="display:flex; gap:8px; margin-bottom:16px;">
                        <input type="hidden" name="email" value="<%= request.getAttribute("customerEmail") %>"/>
                        <input type="text" name="search" placeholder="Search item..." value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>" style="flex:1; padding:10px; border:1px solid var(--border); border-radius:var(--radius-sm); outline:none; font-family:inherit;" />
                        <button type="submit" class="btn btn-outline" style="padding:10px 16px;">Search</button>
                    </form>
                    <div class="component-list" style="max-height:220px;">
                        <% 
                        List<com.techmart.service.Product> searchResults = (List<com.techmart.service.Product>) request.getAttribute("searchResults");
                        if (searchResults != null && !searchResults.isEmpty()) {
                            for (com.techmart.service.Product p : searchResults) { 
                        %>
                        <div class="component-item" style="flex-direction:column; align-items:flex-start; padding:12px; background:var(--gray-50); border-radius:var(--radius-sm); border:1px solid var(--border);">
                            <div style="display:flex; justify-content:space-between; width:100%; margin-bottom:8px;">
                                <span style="font-weight:600; font-size:14px;"><%= p.getItemName() %></span>
                                <span style="color:var(--amber-500); font-weight:700;">Rs. <%= p.getPrice() %></span>
                            </div>
                            <div style="display:flex; gap:8px; width:100%;">
                                <a href="dashboard?action=add&itemId=<%= p.getItemId() %>&qty=1&email=<%= request.getAttribute("customerEmail") %>" class="btn btn-outline" style="flex:1; justify-content:center; padding:6px; font-size:12px; text-decoration:none;"><i class="las la-shopping-cart"></i> Cart</a>
                                <a href="dashboard?action=quickbuy&itemId=<%= p.getItemId() %>&qty=1&email=<%= request.getAttribute("customerEmail") %>" class="btn btn-primary" style="flex:1; justify-content:center; padding:6px; font-size:12px; text-decoration:none;"><i class="las la-bolt"></i> Buy</a>
                            </div>
                        </div>
                        <% 
                            }
                        } else if (request.getParameter("search") != null) { 
                        %>
                        <p style="color:var(--gray-500); font-size:13px;">No products found.</p>
                        <% } else { %>
                        <p style="color:var(--gray-400); font-size:13px; text-align:center; margin-top:20px;">Enter a keyword to search.</p>
                        <% } %>
                    </div>
                </div>

           
                <div class="card" style="border-top: 4px solid var(--purple-500);">
                    <div class="card-header">
                        <h3 class="card-title"><i class="las la-shopping-cart"></i> Stateful Session Cart</h3>
                    </div>
                    <div style="margin-bottom:16px; font-size:12px; color:var(--gray-500); font-family:monospace;">
                        Session: <%= session.getId().substring(0, Math.min(20, session.getId().length())) %>...
                    </div>
                    <div class="component-list" style="max-height:160px; margin-bottom:16px;">
                        <% 
                        Map<Integer, Integer> cartItems = (Map<Integer, Integer>) request.getAttribute("cartItems");
                        if (cartItems != null && !cartItems.isEmpty()) {
                            for (Map.Entry<Integer, Integer> entry : cartItems.entrySet()) {
                        %>
                        <div class="status-item" style="padding:8px 12px; margin-bottom:4px;">
                            <span class="status-item-label">Product ID: <%= entry.getKey() %></span>
                            <span class="status-item-value" style="color:var(--purple-500); font-size:14px; font-weight:700;">Qty: <%= entry.getValue() %></span>
                        </div>
                        <%  }
                        } else { %>
                        <p style="text-align:center; color:var(--gray-400); font-size:13px; padding:20px;">Cart is empty</p>
                        <% } %>
                    </div>
                    <% if (cartItems != null && !cartItems.isEmpty()) { %>
                    <a href="dashboard?action=checkout&email=<%= request.getAttribute("customerEmail") %>" class="btn btn-primary" style="width:100%; justify-content:center; background:var(--purple-500); text-decoration:none;"><i class="las la-lock"></i> ACID Checkout</a>
                    <% } %>
                </div>

     
                <div class="card" style="border-top: 4px solid var(--red-500);">
                    <div class="card-header">
                        <h3 class="card-title"><i class="las la-fire"></i> Concurrency Simulator</h3>
                    </div>
                    <p style="font-size:12px; color:var(--gray-500); margin-bottom:16px;">Inject 50 concurrent checkout requests to test Bean managed concurrency and DB locks.</p>
                    <form method="GET" action="dashboard" style="display:flex; gap:8px; margin-bottom:20px;">
                        <input type="hidden" name="action" value="simulate"/>
                        <input type="number" name="itemId" value="1" min="1" max="5" style="width:60px; padding:8px; border:1px solid var(--border); border-radius:var(--radius-sm); outline:none;" />
                        <button type="submit" class="btn" style="background:var(--red-500); color:white; flex:1; justify-content:center; border:none; padding:10px;">Inject Load</button>
                    </form>
                    <div style="background:var(--gray-50); padding:12px; border-radius:var(--radius-md);">
                        <div style="display:flex; justify-content:space-between; font-size:12px; margin-bottom:8px;">
                            <span style="color:var(--gray-600);">Total Requests:</span>
                            <span style="font-weight:700;"><%= request.getAttribute("totalSimulatedRequests") %></span>
                        </div>
                        <div style="display:flex; justify-content:space-between; font-size:12px; margin-bottom:8px;">
                            <span style="color:var(--green-600);">Successful (Processed):</span>
                            <span style="font-weight:700; color:var(--green-600);"><%= request.getAttribute("successfulSimulations") %></span>
                        </div>
                        <div style="display:flex; justify-content:space-between; font-size:12px;">
                            <span style="color:var(--red-500);">Failed (Blocked/Collision):</span>
                            <span style="font-weight:700; color:var(--red-500);"><%= request.getAttribute("failedSimulations") %></span>
                        </div>
                    </div>
                </div>
            </div>

  
            <div class="grid-3col animate-in animate-in-3">

     
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title">Operational Metrics (BMC)</h3>
                    </div>
                    <% if (metrics != null && !metrics.isEmpty()) {
                        for (Map.Entry<String, Long> entry : metrics.entrySet()) { %>
                    <div class="metric-row">
                        <span class="metric-label"><%= entry.getKey().replace(".", " ").toUpperCase() %></span>
                        <span class="metric-value"><%= String.format("%,d", entry.getValue()) %></span>
                    </div>
                    <% } } else { %>
                    <p style="color:var(--gray-500); text-align:center; padding:20px">No metrics recorded yet.</p>
                    <% } %>
                </div>

   
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title">System Status</h3>
                    </div>
                    <div class="meeting-card">
                        <div class="meeting-title">Payara Server Active</div>
                        <div class="meeting-time">Uptime: <%= uptime != null ? uptime : "N/A" %></div>
                        <button class="meeting-btn" onclick="window.open('http://localhost:4848','_blank')"><i class="las la-server"></i> Admin Console</button>
                    </div>
                    <div style="margin-top:16px">
                        <div class="status-item">
                            <div class="status-item-left">
                                <span class="status-dot online"></span>
                                <span class="status-item-label">HTTP Listener</span>
                            </div>
                            <span class="status-item-value">:8080</span>
                        </div>
                        <div class="status-item" style="margin-top:8px">
                            <div class="status-item-left">
                                <span class="status-dot online"></span>
                                <span class="status-item-label">JMS Broker</span>
                            </div>
                            <span class="status-item-value">:7676</span>
                        </div>
                        <div class="status-item" style="margin-top:8px">
                            <div class="status-item-left">
                                <span class="status-dot online"></span>
                                <span class="status-item-label">Environment</span>
                            </div>
                            <span class="status-item-value"><%= env %></span>
                        </div>
                    </div>
                </div>

      
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title">EJB Components</h3>
                        <a href="#" class="card-action">12 Beans</a>
                    </div>
                    <div class="component-list">
                        <div class="component-item">
                            <div class="component-icon singleton">S</div>
                            <div class="component-info">
                                <div class="component-name">InventoryCache</div>
                                <div class="component-desc">Singleton · CMC · @Startup</div>
                            </div>
                        </div>
                        <div class="component-item">
                            <div class="component-icon singleton">S</div>
                            <div class="component-info">
                                <div class="component-name">AppConfigBean</div>
                                <div class="component-desc">Singleton · BMC · @Startup</div>
                            </div>
                        </div>
                        <div class="component-item">
                            <div class="component-icon stateless">L</div>
                            <div class="component-info">
                                <div class="component-name">CheckOutService</div>
                                <div class="component-desc">Stateless · JTA Transaction</div>
                            </div>
                        </div>
                        <div class="component-item">
                            <div class="component-icon stateful">F</div>
                            <div class="component-info">
                                <div class="component-name">ShoppingCartBean</div>
                                <div class="component-desc">Stateful · @Remove lifecycle</div>
                            </div>
                        </div>
                        <div class="component-item">
                            <div class="component-icon mdb">M</div>
                            <div class="component-info">
                                <div class="component-name">OrderProcessorMDB</div>
                                <div class="component-desc">MDB · JMS Queue Consumer</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

    
            <div class="grid-bottom animate-in animate-in-5">

            
                <div class="card config-card">
                    <div class="card-header">
                        <h3 class="card-title">Runtime Configuration</h3>
                        <a href="#" class="card-action">View All</a>
                    </div>
                    <% if (configMap != null) {
                        String[] keys = {"platform.environment", "platform.version", "business.currency", "perf.async.pool.max", "perf.jms.retry.max", "perf.cache.refresh.minutes"};
                        for (String key : keys) {
                            String val = configMap.get(key);
                            if (val != null) { %>
                    <div class="config-item">
                        <span class="config-key"><%= key %></span>
                        <span class="config-val"><%= val %></span>
                    </div>
                    <% } } } %>
                </div>


                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title">Cache Performance (CMC)</h3>
                    </div>
                    <div class="cache-stat">
                        <div class="cache-big"><%= totalCache %></div>
                        <div class="cache-label">Total Cache Refreshes</div>
                    </div>
                    <div class="cache-details">
                        <div class="cache-detail-item">
                            <div class="cdv"><%= totalAsync %></div>
                            <div class="cdl">Async Tasks</div>
                        </div>
                        <div class="cache-detail-item">
                            <div class="cdv">CMC</div>
                            <div class="cdl">Lock Strategy</div>
                        </div>
                    </div>
                    <p style="text-align:center; font-size:11px; color:var(--gray-400); margin-top:12px">
                        <%= cacheStats != null ? cacheStats : "Cache statistics unavailable." %>
                    </p>
                </div>


                <div class="card uptime-card">
                    <div class="uptime-label">Server Uptime</div>
                    <div class="uptime-time" id="uptime-display"><%= uptime != null ? uptime : "0d 0h 0m 0s" %></div>
                    <div class="uptime-sub"><%= healthSummary != null ? healthSummary : "" %></div>
                    <div class="uptime-buttons">
                        <button class="uptime-btn refresh-btn" title="Refresh" onclick="window.location.reload()"><i class="las la-sync"></i></button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>

#!/bin/bash

# 1. Installation des dépendances
export DEBIAN_FRONTEND=noninteractive
sudo apt-get update -y
sudo apt-get install -y apache2 php libapache2-mod-php # PHP pour les Live Metrics réels

# 2. Récupération des données système pour le premier affichage
VM_NAME=$(hostname)
IP_PUB=$(curl -s ifconfig.me)

# --- Génération du fichier PHP pour le site interactif ---
cat <<EOF > /var/www/html/index.php
<?php
// Petit script pour récupérer les metrics en temps réel
\$load = sys_getloadavg();
\$free_mem = shell_exec("free -m | grep Mem | awk '{print \$4}'");
?>
<!DOCTYPE html>
<html lang="fr" data-theme="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Azure Architecture Masterclass</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        :root[data-theme="dark"] {
            --bg: #030712; --card-bg: rgba(255, 255, 255, 0.03);
            --text: #f3f4f6; --text-muted: #9ca3af; --border: rgba(255, 255, 255, 0.1);
            --accent: #0078d4; --accent-glow: rgba(0, 120, 212, 0.3);
        }
        :root[data-theme="light"] {
            --bg: #f9fafb; --card-bg: #ffffff;
            --text: #111827; --text-muted: #4b5563; --border: #e5e7eb;
            --accent: #0078d4; --accent-glow: rgba(0, 120, 212, 0.1);
        }

        body { 
            background: var(--bg); color: var(--text); 
            font-family: 'Inter', system-ui, sans-serif; 
            transition: background 0.3s, color 0.3s;
            overflow-x: hidden;
        }

        /* --- Parallaxe Background --- */
        #parallax-bg {
            position: fixed; top: 0; left: 0; width: 110%; height: 110%;
            background: radial-gradient(circle at 50% 50%, var(--accent-glow) 0%, transparent 70%);
            z-index: -1; transition: transform 0.1s ease-out;
        }

        /* --- Theme Toggle --- */
        .theme-switch {
            position: fixed; top: 20px; right: 20px; z-index: 10002;
            cursor: pointer; padding: 10px; border-radius: 50%;
            background: var(--card-bg); border: 1px solid var(--border);
        }

        /* --- Breadcrumbs --- */
        .breadcrumb-nav { font-size: 0.8rem; color: var(--accent); text-transform: uppercase; letter-spacing: 1px; }

        /* --- Glass Cards --- */
        .glass-card {
            background: var(--card-bg); backdrop-filter: blur(10px);
            border: 1px solid var(--border); border-radius: 20px;
            padding: 2rem; transition: 0.3s ease; cursor: pointer; height: 100%;
        }
        .glass-card:hover { border-color: var(--accent); transform: translateY(-5px); }
        .card-expand { max-height: 0; opacity: 0; overflow: hidden; transition: 0.5s ease; }
        .active .card-expand { max-height: 1000px; opacity: 1; margin-top: 1.5rem; }

        /* --- Table Styling --- */
        .compare-table { width: 100%; font-size: 0.9rem; border-collapse: collapse; }
        .compare-table th, .compare-table td { padding: 12px; border-bottom: 1px solid var(--border); text-align: left; }
        .compare-table th { color: var(--accent); }

        /* --- Metrics Badge --- */
        .metric-badge { background: rgba(0, 120, 212, 0.1); border: 1px solid var(--accent); color: var(--accent); padding: 5px 12px; border-radius: 8px; font-size: 0.75rem; font-weight: bold; }

        .glossary-term { color: var(--accent); border-bottom: 1px dashed var(--accent); cursor: help; }

        /* --- Intro Animation --- */
        #intro-screen {
            position: fixed; inset: 0; background: #000; z-index: 10005;
            display: flex; flex-direction: column; align-items: center; justify-content: center;
            transition: 0.8s ease-in-out;
        }
    </style>
</head>
<body>

    <div id="parallax-bg"></div>

    <div class="theme-switch" onclick="toggleTheme()">
        <i id="theme-icon" class="fas fa-moon"></i>
    </div>

    <div id="intro-screen">
        <div class="text-center">
            <div class="spinner-border text-primary mb-3" role="status"></div>
            <p class="font-monospace text-primary">INITIALIZING_AZURE_DASHBOARD...</p>
        </div>
    </div>

    <main class="container py-5 mt-4">
        <nav class="breadcrumb-nav mb-3">Azure > Infrastructure > ITSCM_Project</nav>
        
        <header class="mb-5">
            <h1 class="display-4 fw-bold">Architecture Cloud & Automation</h1>
            <div class="d-flex gap-3 mt-3">
                <span class="metric-badge"><i class="fas fa-microchip me-1"></i> CPU Load: <?php echo \$load[0]; ?></span>
                <span class="metric-badge"><i class="fas fa-memory me-1"></i> Free RAM: <?php echo \$free_mem; ?> MB</span>
                <span class="metric-badge"><i class="fas fa-network-wired me-1"></i> VM: $VM_NAME</span>
            </div>
        </header>

        <div class="row g-4">
            <div class="col-md-12">
                <div class="glass-card" onclick="this.classList.toggle('active')">
                    <div class="d-flex justify-content-between align-items-center">
                        <h3><i class="fas fa-exchange-alt me-2 text-primary"></i> On-Premise vs Cloud Azure</h3>
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <div class="card-expand">
                        <p>L'<strong>On-Premise</strong> désigne l'hébergement "dans le placard" : vous possédez physiquement les serveurs. Le <strong>Cloud</strong> est une dématérialisation totale.</p>
                        <table class="compare-table mt-3">
                            <thead>
                                <tr><th>Critère</th><th>On-Premise (Classique)</th><th>Azure (Cloud)</th></tr>
                            </thead>
                            <tbody>
                                <tr><td>Coût Initial</td><td>Élevé (CapEx) - Achat matériel</td><td>Nul (OpEx) - Paiement à l'usage</td></tr>
                                <tr><td>Maintenance</td><td>Équipe dédiée requise 24/7</td><td>Gérée par Microsoft</td></tr>
                                <li>Sécurité</td><td>Physique (Verrous, Alarme)</td><td>Cyber-sécurité de classe mondiale</td></tr>
                                <tr><td>Scalabilité</td><td>Lente (Commander du matos)</td><td>Instantanée (Auto-scaling)</td></tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <div class="col-md-6">
                <div class="glass-card" onclick="this.classList.toggle('active')">
                    <div class="d-flex justify-content-between align-items-center">
                        <h3><i class="fab fa-microsoft me-2 text-primary"></i> L'Univers Azure</h3>
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <div class="card-expand">
                        <p>Azure est le moteur de services de Microsoft. Ce n'est pas qu'une VM, c'est une <span class="glossary-term" title="L'ensemble des technologies REST qui permettent de piloter Azure par code">API Géante</span>. Tout objet créé est défini par un fichier <span class="glossary-term" title="JavaScript Object Notation : Le format texte universel pour les données">JSON</span>.</p>
                        <p class="small text-muted">A quoi ça sert ? Pour les <strong>Développeurs</strong>, ça offre des outils de déploiement continu. Pour les <strong>Data Scientists</strong>, une puissance de calcul IA infinie.</p>
                    </div>
                </div>
            </div>

            <div class="col-md-6">
                <div class="glass-card" onclick="this.classList.toggle('active')">
                    <div class="d-flex justify-content-between align-items-center">
                        <h3><i class="fas fa-book me-2 text-primary"></i> Petit Lexique</h3>
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <div class="card-expand">
                        <ul class="list-unstyled">
                            <li><strong>IaC :</strong> Infrastructure as Code. On écrit le serveur au lieu de le cliquer.</li>
                            <li><strong>VNET :</strong> Réseau Virtuel. Votre périmètre privé dans le Cloud.</li>
                            <li><strong>SLA :</strong> Garantie de temps de fonctionnement (ex: 99.9%).</li>
                            <li><strong>RGPD :</strong> Conformité européenne pour la protection des données.</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>

        

        <div class="mt-5 p-5 glass-card text-center" style="border: 2px dashed var(--accent);">
            <i class="fas fa-file-pdf fa-3x text-danger mb-3"></i>
            <h2>Rapport de Projet & Laboratoire Technique</h2>
            <p class="text-secondary mb-4">Ce document contient l'intégralité de la démarche, les captures d'écran des configurations Azure et le code source Bash utilisé pour ce déploiement.</p>
            <a href="https://itscm-my.sharepoint.com/:b:/g/personal/o_jabali_student_itscm_be/IQC2vN0pAVt3SKqbYJUpSco2Aa-icoyjwF3PYmD36Jr0okk?e=TXazKe" target="_blank" class="btn btn-primary btn-lg px-5 py-3 rounded-pill fw-bold">
                <i class="fas fa-download me-2"></i> LIEN VERS PDF DU PROJET (LABORATOIRE)
            </a>
        </div>

        <footer class="mt-5 text-center text-muted small pb-5">
            Node: $VM_NAME | Public IP: $IP_PUB<br>
            Projet Académique | ITSCM | 2026
        </footer>
    </main>

    <script>
        // Parallaxe
        document.addEventListener('mousemove', (e) => {
            const moveX = (e.clientX - window.innerWidth / 2) * 0.01;
            const moveY = (e.clientY - window.innerHeight / 2) * 0.01;
            document.getElementById('parallax-bg').style.transform = \`translate(\${moveX}px, \${moveY}px)\`;
        });

        // Theme Toggle
        function toggleTheme() {
            const root = document.documentElement;
            const icon = document.getElementById('theme-icon');
            if (root.getAttribute('data-theme') === 'dark') {
                root.setAttribute('data-theme', 'light');
                icon.className = 'fas fa-sun';
            } else {
                root.setAttribute('data-theme', 'dark');
                icon.className = 'fas fa-moon';
            }
        }

        // Animation de fin d'intro
        window.addEventListener('load', () => {
            setTimeout(() => {
                document.getElementById('intro-screen').style.opacity = '0';
                setTimeout(() => document.getElementById('intro-screen').style.display = 'none', 800);
            }, 1000);
        });
    </script>
</body>
</html>
EOF

# Attribution des droits et redémarrage
sudo chown -R www-data:www-data /var/www/html
sudo a2enmod php
sudo systemctl restart apache2

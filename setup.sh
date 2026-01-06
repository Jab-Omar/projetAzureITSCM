#!/bin/bash

# 1. Setup Environnement
export DEBIAN_FRONTEND=noninteractive
sudo apt-get update -y
sudo apt-get install -y apache2

# Données système pour le dynamisme
VM_NAME=$(hostname)
UPTIME=$(uptime -p)

# --- Génération de l'Encyclopédie Interactive Azure ---
cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Masterclass Azure | ITSCM</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        :root { 
            --az-blue: #0078d4; 
            --az-cyan: #00f2ff;
            --bg-dark: #02040a;
            --card-bg: rgba(255, 255, 255, 0.03);
            --border-white: rgba(255, 255, 255, 0.08);
        }
        
        body { 
            background: var(--bg-dark); 
            color: #d1d5db; 
            font-family: 'Inter', 'Segoe UI', sans-serif;
            line-height: 1.7;
            margin: 0;
        }

        /* --- Scroll Progress --- */
        #progress-container { position: fixed; top: 0; left: 0; width: 100%; height: 3px; background: transparent; z-index: 10001; }
        #progress-bar { width: 0%; height: 100%; background: linear-gradient(to right, var(--az-blue), var(--az-cyan)); }

        /* --- Intro Sophistiquée --- */
        #intro-overlay {
            position: fixed; inset: 0; background: #000; z-index: 10000;
            display: flex; flex-direction: column; align-items: center; justify-content: center;
            transition: transform 0.8s cubic-bezier(0.7, 0, 0.3, 1);
        }
        .boot-sequence { font-family: 'Consolas', monospace; color: var(--az-cyan); font-size: 0.9rem; max-width: 500px; }

        /* --- Grid & Cards --- */
        .glass-card {
            background: var(--card-bg);
            backdrop-filter: blur(15px);
            border: 1px solid var(--border-white);
            border-radius: 20px;
            padding: 2rem;
            transition: all 0.4s ease;
            cursor: pointer;
            height: 100%;
        }
        .glass-card:hover {
            border-color: var(--az-blue);
            background: rgba(255, 255, 255, 0.06);
            transform: translateY(-5px);
        }
        .card-expand {
            max-height: 0; opacity: 0; overflow: hidden;
            transition: all 0.5s ease;
        }
        .glass-card.active .card-expand { max-height: 1000px; opacity: 1; margin-top: 1.5rem; }
        
        .icon-box {
            width: 45px; height: 45px; background: rgba(0, 120, 212, 0.15);
            border-radius: 10px; display: flex; align-items: center; justify-content: center;
            font-size: 18px; color: var(--az-cyan); margin-bottom: 1rem;
        }

        .category-tag { font-size: 0.7rem; font-weight: 700; color: var(--az-blue); text-transform: uppercase; letter-spacing: 1px; }
        .chevron { transition: transform 0.3s; color: var(--az-blue); font-size: 0.8rem; }
        .glass-card.active .chevron { transform: rotate(180deg); }

        .btn-itscm { background: #fff; color: #000; font-weight: 700; border-radius: 10px; padding: 12px 30px; text-decoration: none; transition: 0.3s; }
        .btn-itscm:hover { box-shadow: 0 0 20px rgba(0, 242, 255, 0.4); transform: scale(1.02); }

    </style>
</head>
<body>

    <div id="progress-container"><div id="progress-bar"></div></div>

    <div id="intro-overlay">
        <div class="boot-sequence" id="boot-text"></div>
        <button class="btn btn-outline-light mt-5" id="btn-ready" style="display:none;" onclick="startApp()">Initialiser la connaissance</button>
    </div>

    <main class="container py-5" style="opacity:0; transition: opacity 1s;" id="app-content">
        <header class="text-center mb-5">
            <h1 class="display-4 fw-bold text-white">Le Guide Suprême Azure</h1>
            <p class="text-secondary fs-5 mx-auto" style="max-width: 800px;">
                Du concept physique au déploiement par code : comprenez pourquoi le Cloud Microsoft est le moteur de l'industrie 4.0.
            </p>
        </header>

        <div class="row g-4">
            <div class="col-md-6">
                <div class="glass-card" onclick="this.classList.toggle('active')">
                    <div class="d-flex justify-content-between">
                        <span class="category-tag">Fondamentaux</span>
                        <i class="fas fa-chevron-down chevron"></i>
                    </div>
                    <div class="icon-box mt-2"><i class="fas fa-cloud"></i></div>
                    <h4>01. C'est quoi le Cloud ?</h4>
                    <div class="card-expand">
                        <p>Le Cloud Computing est la fourniture de services informatiques (serveurs, stockage, bases de données, réseaux, logiciels) via Internet.</p>
                        <p class="small text-secondary">Au lieu de posséder et d'entretenir des centres de données physiques, les entreprises accèdent à la puissance technologique de manière flexible. <br><br>
                        <strong>Les trois piliers :</strong><br>
                        • <strong>L'Agilité :</strong> Déployez des ressources en quelques minutes.<br>
                        • <strong>L'Élasticité :</strong> Payez pour ce que vous utilisez et ajustez la puissance selon la demande réelle.<br>
                        • <strong>L'Économie d'échelle :</strong> Microsoft achète le matériel en masse, réduisant les coûts pour l'utilisateur final.</p>
                    </div>
                </div>
            </div>

            <div class="col-md-6">
                <div class="glass-card" onclick="this.classList.toggle('active')">
                    <div class="d-flex justify-content-between">
                        <span class="category-tag">L'Écosystème</span>
                        <i class="fas fa-chevron-down chevron"></i>
                    </div>
                    <div class="icon-box mt-2"><i class="fab fa-microsoft"></i></div>
                    <h4>02. C'est quoi Azure ?</h4>
                    <div class="card-expand">
                        <p>Azure est la plateforme Cloud de Microsoft. C'est un réseau mondial de plus de 200 centres de données hautement sécurisés.</p>
                        <p class="small text-secondary">Ce n'est pas qu'un site web, c'est un système d'exploitation géant pour la planète. <br><br>
                        • <strong>Portée Mondiale :</strong> Présent dans plus de 60 régions, Azure garantit que vos données sont proches de vos utilisateurs, réduisant la latence (le temps de réponse).<br>
                        • <strong>Confiance :</strong> Azure possède le plus grand nombre de certifications de conformité au monde (RGPD, ISO, HIPAA).</p>
                    </div>
                </div>
            </div>

            <div class="col-md-12">
                <div class="glass-card" onclick="this.classList.toggle('active')">
                    <div class="d-flex justify-content-between">
                        <span class="category-tag">Capacités</span>
                        <i class="fas fa-chevron-down chevron"></i>
                    </div>
                    <div class="icon-box mt-2"><i class="fas fa-rocket"></i></div>
                    <h4>03. Possibilités & Utilité</h4>
                    <div class="card-expand">
                        <div class="row">
                            <div class="col-md-6">
                                <h6 class="text-white">À quoi ça sert ?</h6>
                                <p class="small text-secondary">Absolument tout : héberger des sites web, stocker des pétaoctets de données, créer des applications mobiles, ou gérer des usines connectées (IoT).</p>
                            </div>
                            <div class="col-md-6 border-start border-secondary ps-4">
                                <h6 class="text-white">L'IA & Big Data</h6>
                                <p class="small text-secondary">Azure est le leader de l'IA (partenaire d'OpenAI). Vous pouvez utiliser des modèles comme GPT-4 directement dans vos serveurs pour analyser vos données ou créer des agents intelligents.</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-6">
                <div class="glass-card" onclick="this.classList.toggle('active')">
                    <div class="d-flex justify-content-between">
                        <span class="category-tag">Carrière</span>
                        <i class="fas fa-chevron-down chevron"></i>
                    </div>
                    <div class="icon-box mt-2"><i class="fas fa-users-cog"></i></div>
                    <h4>04. Pour qui & Quels métiers ?</h4>
                    <div class="card-expand">
                        <ul class="small text-secondary">
                            <li><strong class="text-white">Cloud Architect :</strong> Conçoit les plans de l'infrastructure globale.</li>
                            <li><strong class="text-white">DevOps Engineer :</strong> Automatise le déploiement du code (IaC).</li>
                            <li><strong class="text-white">Data Engineer :</strong> Gère le flux massif de données et les bases SQL/NoSQL.</li>
                            <li><strong class="text-white">Security Engineer :</strong> Surveille les menaces et configure les pare-feu.</li>
                        </ul>
                        <p class="small">C'est intéressant pour toute entreprise voulant supprimer la maintenance matérielle pour se concentrer sur son métier.</p>
                    </div>
                </div>
            </div>

            <div class="col-md-6">
                <div class="glass-card" onclick="this.classList.toggle('active')">
                    <div class="d-flex justify-content-between">
                        <span class="category-tag">Technique</span>
                        <i class="fas fa-chevron-down chevron"></i>
                    </div>
                    <div class="icon-box mt-2"><i class="fas fa-file-code"></i></div>
                    <h4>05. Sous le capot : JSON & REST API</h4>
                    <div class="card-expand">
                        <p>C'est ici que réside la magie de l'IaC. Dans Azure, <span class="text-white fw-bold">chaque ressource est un objet JSON.</span></p>
                        <p class="small text-secondary">Quand vous créez un serveur via le portail, Azure envoie en réalité une requête <strong>REST API</strong> au contrôleur Azure (ARM). <br><br>
                        Puisque tout est géré par des messages JSON, nous pouvons stocker la configuration d'un datacenter complet dans un simple fichier texte. C'est ce qui permet de déployer ce serveur via un script sans intervention humaine.</p>
                    </div>
                </div>
            </div>
        </div>

        <div class="mt-5 text-center">
            <div class="p-5 glass-card" style="cursor: default;">
                <h3 class="text-white">Portail de Connaissance</h3>
                <p class="text-secondary mb-4">Accédez au manuel technique SharePoint pour explorer les travaux pratiques détaillés de cette session.</p>
                <a href="https://itscm-my.sharepoint.com/:b:/g/personal/o_jabali_student_itscm_be/IQC2vN0pAVt3SKqbYJUpSco2Aa-icoyjwF3PYmD36Jr0okk?e=TXazKe" target="_blank" class="btn-itscm">
                    <i class="fas fa-file-pdf me-2"></i> Consulter le Manuel (SharePoint)
                </a>
            </div>
        </div>

        <footer class="mt-5 py-4 border-top border-secondary text-center text-secondary small">
            <p>Déploiement Automatisé | Node: $VM_NAME | $UPTIME</p>
            <p>© 2026 - Institut Technique Cardinal Mercier</p>
        </footer>
    </main>

    <script>
        // Progress Bar
        window.onscroll = function() {
            let winScroll = document.body.scrollTop || document.documentElement.scrollTop;
            let height = document.documentElement.scrollHeight - document.documentElement.clientHeight;
            let scrolled = (winScroll / height) * 100;
            document.getElementById("progress-bar").style.width = scrolled + "%";
        };

        // Boot Sequence
        const lines = [
            "> Initialisation des modules Azure...",
            "> Connexion API Management : OK",
            "> Parsing des objets JSON : SUCCESS",
            "> Déploiement du Dashboard ITSCM...",
            "> Système prêt."
        ];
        let i = 0;
        function type() {
            if (i < lines.length) {
                document.getElementById('boot-text').innerHTML += lines[i] + "<br>";
                i++; setTimeout(type, 300);
            } else {
                document.getElementById('btn-ready').style.display = 'block';
            }
        }
        type();

        function startApp() {
            document.getElementById('intro-overlay').style.transform = 'translateY(-100%)';
            document.getElementById('app-content').style.opacity = '1';
        }
    </script>
</body>
</html>
EOF

sudo systemctl restart apache2

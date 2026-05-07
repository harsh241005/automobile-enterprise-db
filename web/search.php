<?php
// ============================================================
// DriveNet Inventory Portal — search.php
// Oracle OCI8 + Bootstrap 5 | Single-file PHP Application
// ============================================================
include 'db_connect.php';

// ── PRE-FETCH: Dropdown data ─────────────────────────────────
$model_query = "SELECT DISTINCT model_name FROM Model ORDER BY model_name";
$model_stmt = oci_parse($conn, $model_query);
oci_execute($model_stmt);
$models = [];
while ($row = oci_fetch_array($model_stmt, OCI_ASSOC)) {
    $models[] = $row['MODEL_NAME'];
}
oci_free_statement($model_stmt);

$location_query = "SELECT DISTINCT location FROM Dealer ORDER BY location";
$location_stmt = oci_parse($conn, $location_query);
oci_execute($location_stmt);
$locations = [];
while ($row = oci_fetch_array($location_stmt, OCI_ASSOC)) {
    $locations[] = $row['LOCATION'];
}
oci_free_statement($location_stmt);

// ── POST HANDLER: Run search query ───────────────────────────
$search_results = [];
$has_results = false;
$searched = false;
$search_model = '';
$search_location = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $searched = true;
    $search_model = trim($_POST['car_model'] ?? '');
    $search_location = trim($_POST['state'] ?? '');

    $query = "
        SELECT
            d.dealer_name,
            v.VIN,
            c.colour_name,
            e.engine_type,
            e.fuel_type,
            t.transmission_type
        FROM Vehicle v
        JOIN Model m ON v.model_id = m.model_id
        JOIN Colours c ON v.colour_id = c.colour_id
        JOIN Engine e ON v.engine_id = e.engine_id
        JOIN Transmission t ON v.transmission_id = t.transmission_id
        JOIN Dealer d ON v.dealer_id = d.dealer_id
        LEFT JOIN Sold_Vehicle sv ON v.VIN = sv.VIN
        WHERE UPPER(m.model_name) = UPPER(:model_input)
        AND UPPER(d.location) = UPPER(:location_input)
        AND sv.VIN IS NULL
        ORDER BY d.dealer_name, v.VIN
    ";

    $stid = oci_parse($conn, $query);
    oci_bind_by_name($stid, ':model_input', $search_model);
    oci_bind_by_name($stid, ':location_input', $search_location);
    oci_execute($stid);

    while ($row = oci_fetch_array($stid, OCI_ASSOC + OCI_RETURN_NULLS)) {
        $has_results = true;
        $search_results[] = $row;
    }

    oci_free_statement($stid);
    oci_close($conn);
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DriveNet — Inventory Portal</title>
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=DM+Sans:ital,opsz,wght@0,9..40,300;0,9..40,400;0,9..40,500;0,9..40,600;1,9..40,300&display=swap" rel="stylesheet">
    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <style>
        /* ── TOKENS ──────────────────────────────────────────── */
        :root {
            --bg: #0d0d0f;
            --surface: #141417;
            --surface-2: #1c1c21;
            --border: #2a2a30;
            --accent: #e8c94a;
            --accent-dim: rgba(232, 201, 74, 0.12);
            --text: #e8e8ec;
            --muted: #7a7a88;
            --danger: #e85a4f;
            --success: #4fb87a;
            --radius: 12px;
            --radius-sm: 6px;
        }

        /* ── BASE ────────────────────────────────────────────── */
        *, *::before, *::after { box-sizing: border-box; }
        body {
            background: var(--bg);
            color: var(--text);
            font-family: 'DM Sans', sans-serif;
            font-size: 15px;
            min-height: 100vh;
            overflow-x: hidden;
        }

        /* ── BACKGROUND TEXTURE ──────────────────────────────── */
        body::before {
            content: '';
            position: fixed;
            inset: 0;
            background-image:
                radial-gradient(ellipse 80% 60% at 70% -10%, rgba(232,201,74,0.06) 0%, transparent 60%),
                radial-gradient(ellipse 50% 40% at 0% 80%, rgba(232,201,74,0.03) 0%, transparent 50%);
            pointer-events: none;
            z-index: 0;
        }

        /* ── NAVBAR ──────────────────────────────────────────── */
        .site-nav {
            background: var(--surface);
            border-bottom: 1px solid var(--border);
            padding: 0 2rem;
            height: 64px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: sticky;
            top: 0;
            z-index: 100;
            backdrop-filter: blur(12px);
        }

        .site-nav .brand {
            display: flex;
            align-items: center;
            gap: 12px;
            text-decoration: none;
        }

        .brand-icon {
            width: 36px;
            height: 36px;
            background: var(--accent);
            border-radius: var(--radius-sm);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #000;
            font-size: 18px;
        }

        .brand-name {
            font-family: 'Bebas Neue', sans-serif;
            font-size: 1.5rem;
            letter-spacing: 2px;
            color: var(--text);
        }

        .brand-name span { color: var(--accent); }

        .nav-tag {
            font-size: 11px;
            font-weight: 500;
            color: var(--muted);
            letter-spacing: 1.5px;
            text-transform: uppercase;
            border: 1px solid var(--border);
            padding: 3px 10px;
            border-radius: 20px;
        }

        /* ── MAIN LAYOUT ─────────────────────────────────────── */
        .main-wrap {
            position: relative;
            z-index: 1;
            max-width: 1100px;
            margin: 0 auto;
            padding: 3rem 1.5rem 5rem;
        }

        /* ── HERO ────────────────────────────────────────────── */
        .hero { margin-bottom: 2.5rem; }

        .hero-eyebrow {
            font-size: 11px;
            font-weight: 600;
            letter-spacing: 3px;
            text-transform: uppercase;
            color: var(--accent);
            margin-bottom: 0.75rem;
        }

        .hero h1 {
            font-family: 'Bebas Neue', sans-serif;
            font-size: clamp(2.8rem, 6vw, 5rem);
            letter-spacing: 3px;
            line-height: 1;
            color: var(--text);
            margin: 0 0 0.75rem;
        }

        .hero h1 em { color: var(--accent); font-style: normal; }

        .hero p {
            color: var(--muted);
            font-size: 15px;
            font-weight: 300;
            max-width: 480px;
            line-height: 1.7;
            margin: 0;
        }

        /* ── SEARCH CARD ─────────────────────────────────────── */
        .search-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius);
            padding: 2rem;
            margin-bottom: 2.5rem;
            position: relative;
            overflow: hidden;
        }

        .search-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0;
            height: 2px;
            background: linear-gradient(90deg, var(--accent) 0%, transparent 60%);
        }

        .search-card-header {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 1.75rem;
        }

        .search-card-header .icon {
            width: 34px;
            height: 34px;
            background: var(--accent-dim);
            border: 1px solid rgba(232,201,74,0.25);
            border-radius: var(--radius-sm);
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--accent);
            font-size: 16px;
        }

        .search-card-header h5 {
            font-size: 15px;
            font-weight: 600;
            margin: 0;
            color: var(--text);
        }

        .search-card-header p {
            font-size: 12px;
            color: var(--muted);
            margin: 0;
        }

        /* ── FORM CONTROLS ───────────────────────────────────── */
        .form-group label {
            font-size: 11px;
            font-weight: 600;
            letter-spacing: 1.5px;
            text-transform: uppercase;
            color: var(--muted);
            margin-bottom: 8px;
            display: block;
        }

        .form-select-dark {
            width: 100%;
            background: var(--surface-2);
            border: 1px solid var(--border);
            border-radius: var(--radius-sm);
            color: var(--text);
            padding: 11px 40px 11px 14px;
            font-family: 'DM Sans', sans-serif;
            font-size: 14px;
            font-weight: 400;
            appearance: none;
            -webkit-appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' fill='%237a7a88' viewBox='0 0 16 16'%3E%3Cpath d='M7.247 11.14 2.451 5.658C1.885 5.013 2.345 4 3.204 4h9.592a1 1 0 0 1 .753 1.659l-4.796 5.48a1 1 0 0 1-1.506 0z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 14px center;
            cursor: pointer;
            transition: border-color .2s, box-shadow .2s;
            outline: none;
        }

        .form-select-dark:focus {
            border-color: var(--accent);
            box-shadow: 0 0 0 3px rgba(232,201,74,0.12);
        }

        .form-select-dark option {
            background: #1c1c21;
            color: var(--text);
        }

        /* ── SEARCH BUTTON ───────────────────────────────────── */
        .btn-search {
            width: 100%;
            height: 46px;
            background: var(--accent);
            color: #000;
            border: none;
            border-radius: var(--radius-sm);
            font-family: 'DM Sans', sans-serif;
            font-size: 14px;
            font-weight: 700;
            letter-spacing: 1px;
            text-transform: uppercase;
            cursor: pointer;
            transition: background .2s, transform .1s, box-shadow .2s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .btn-search:hover {
            background: #f0d460;
            box-shadow: 0 4px 20px rgba(232,201,74,0.25);
            transform: translateY(-1px);
        }

        .btn-search:active { transform: translateY(0); }

        /* ── DIVIDER ─────────────────────────────────────────── */
        .section-label {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 1.25rem;
        }

        .section-label h4 {
            font-size: 13px;
            font-weight: 600;
            letter-spacing: 1.5px;
            text-transform: uppercase;
            color: var(--muted);
            margin: 0;
            white-space: nowrap;
        }

        .section-label-line {
            flex: 1;
            height: 1px;
            background: var(--border);
        }

        .result-meta {
            font-size: 13px;
            color: var(--muted);
            margin-bottom: 1rem;
        }

        .result-meta strong {
            color: var(--accent);
            font-weight: 600;
        }

        /* ── RESULTS TABLE ───────────────────────────────────── */
        .results-wrap {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius);
            overflow: hidden;
            animation: fadeUp .35s ease both;
        }

        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(16px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .table-responsive { overflow-x: auto; }

        .results-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 14px;
        }

        .results-table thead tr {
            background: var(--surface-2);
            border-bottom: 1px solid var(--border);
        }

        .results-table thead th {
            padding: 13px 16px;
            font-size: 10px;
            font-weight: 700;
            letter-spacing: 1.8px;
            text-transform: uppercase;
            color: var(--muted);
            white-space: nowrap;
        }

        .results-table tbody tr {
            border-bottom: 1px solid var(--border);
            transition: background .15s;
        }

        .results-table tbody tr:last-child { border-bottom: none; }
        .results-table tbody tr:hover { background: var(--surface-2); }

        .results-table tbody td {
            padding: 14px 16px;
            color: var(--text);
            vertical-align: middle;
        }

        .vin-badge {
            font-family: 'Courier New', monospace;
            font-size: 11px;
            font-weight: 600;
            letter-spacing: 1px;
            background: var(--surface-2);
            border: 1px solid var(--border);
            color: var(--accent);
            padding: 3px 8px;
            border-radius: var(--radius-sm);
            white-space: nowrap;
        }

        .fuel-badge {
            font-size: 10px;
            font-weight: 600;
            letter-spacing: 1px;
            text-transform: uppercase;
            padding: 2px 7px;
            border-radius: 20px;
        }

        .fuel-petrol { background: rgba(232,120,74,0.15); color: #e8784a; border: 1px solid rgba(232,120,74,0.25); }
        .fuel-diesel { background: rgba(74,140,232,0.15); color: #4a8ce8; border: 1px solid rgba(74,140,232,0.25); }
        .fuel-hybrid { background: rgba(79,184,122,0.15); color: #4fb87a; border: 1px solid rgba(79,184,122,0.25); }
        .fuel-electric { background: rgba(232,201,74,0.15); color: #e8c94a; border: 1px solid rgba(232,201,74,0.25); }
        .fuel-cng { background: rgba(180,74,232,0.15); color: #b44ae8; border: 1px solid rgba(180,74,232,0.25); }

        .colour-dot {
            display: inline-block;
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background: var(--accent);
            margin-right: 7px;
            vertical-align: middle;
        }

        /* ── EMPTY STATE ─────────────────────────────────────── */
        .empty-state {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius);
            padding: 3rem 2rem;
            text-align: center;
            animation: fadeUp .35s ease both;
        }

        .empty-icon {
            font-size: 2.5rem;
            color: var(--muted);
            margin-bottom: 1rem;
        }

        .empty-state h5 {
            font-size: 16px;
            font-weight: 600;
            color: var(--text);
            margin-bottom: 0.5rem;
        }

        .empty-state p {
            color: var(--muted);
            font-size: 14px;
            margin: 0;
        }

        /* ── FOOTER ──────────────────────────────────────────── */
        .site-footer {
            position: relative;
            z-index: 1;
            border-top: 1px solid var(--border);
            padding: 1.5rem 2rem;
            text-align: center;
            font-size: 12px;
            color: var(--muted);
        }

        /* ── RESPONSIVE ──────────────────────────────────────── */
        @media (max-width: 640px) {
            .main-wrap { padding: 2rem 1rem 4rem; }
            .search-card { padding: 1.5rem; }
        }
    </style>
</head>
<body>
    <!-- ── NAVBAR ───────────────────────────────────────────────── -->
    <nav class="site-nav">
        <a class="brand" href="#">
            <div class="brand-icon">
                <i class="bi bi-hexagon-fill"></i>
            </div>
            <span class="brand-name">Drive<span>Net</span></span>
        </a>
        <span class="nav-tag">Inventory Portal</span>
    </nav>

    <!-- ── MAIN CONTENT ─────────────────────────────────────────── -->
    <main class="main-wrap">
        <!-- HERO -->
        <div class="hero">
            <p class="hero-eyebrow">&#9670; Real-Time Stock Lookup</p>
            <h1>Find Your<br><em>Next Vehicle</em></h1>
            <p>Search available inventory across our dealer network. Select a model and region to see what's in stock right now.</p>
        </div>

        <!-- SEARCH CARD -->
        <div class="search-card">
            <div class="search-card-header">
                <div class="icon"><i class="bi bi-search"></i></div>
                <div>
                    <h5>Locate Available Vehicles</h5>
                    <p>Filter by model and region — only unsold stock is shown</p>
                </div>
            </div>

            <form method="POST" action="search.php">
                <div class="row g-3 align-items-end">
                    <div class="col-md-5">
                        <div class="form-group">
                            <label for="car_model">Car Model</label>
                            <select id="car_model" name="car_model" class="form-select-dark" required>
                                <option value="" disabled <?= !$searched ? 'selected' : '' ?>>Choose a model...</option>
                                <?php foreach ($models as $m): ?>
                                    <option value="<?= htmlspecialchars($m) ?>"
                                        <?= ($searched && $m === $search_model) ? 'selected' : '' ?>>
                                        <?= htmlspecialchars($m) ?>
                                    </option>
                                <?php endforeach; ?>
                            </select>
                        </div>
                    </div>
                    <div class="col-md-5">
                        <div class="form-group">
                            <label for="state">Region / State</label>
                            <select id="state" name="state" class="form-select-dark" required>
                                <option value="" disabled <?= !$searched ? 'selected' : '' ?>>Choose a region...</option>
                                <?php foreach ($locations as $loc): ?>
                                    <option value="<?= htmlspecialchars($loc) ?>"
                                        <?= ($searched && $loc === $search_location) ? 'selected' : '' ?>>
                                        <?= htmlspecialchars($loc) ?>
                                    </option>
                                <?php endforeach; ?>
                            </select>
                        </div>
                    </div>
                    <div class="col-md-2">
                        <button type="submit" class="btn-search">
                            <i class="bi bi-search"></i> Search
                        </button>
                    </div>
                </div>
            </form>
        </div>

        <!-- ── RESULTS ───────────────────────────────────────────── -->
        <?php if ($searched): ?>
            <div class="section-label">
                <h4>Results</h4>
                <div class="section-label-line"></div>
            </div>

            <?php if ($has_results): ?>
                <p class="result-meta">
                    Showing <strong><?= count($search_results) ?> vehicle<?= count($search_results) !== 1 ? 's' : '' ?></strong>
                    matching <strong><?= htmlspecialchars($search_model) ?></strong>
                    in <strong><?= htmlspecialchars($search_location) ?></strong>
                </p>

                <div class="results-wrap">
                    <div class="table-responsive">
                        <table class="results-table">
                            <thead>
                                <tr>
                                    <th>Dealer</th>
                                    <th>VIN</th>
                                    <th>Colour</th>
                                    <th>Engine</th>
                                    <th>Fuel</th>
                                    <th>Transmission</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php foreach ($search_results as $row): ?>
                                    <?php $fuel = strtolower(trim($row['FUEL_TYPE'] ?? 'petrol')); $fuel_class = 'fuel-' . $fuel; ?>
                                    <tr>
                                        <td><?= htmlspecialchars($row['DEALER_NAME'] ?? '—') ?></td>
                                        <td><span class="vin-badge"><?= htmlspecialchars($row['VIN'] ?? '—') ?></span></td>
                                        <td><span class="colour-dot"></span><?= htmlspecialchars($row['COLOUR_NAME'] ?? '—') ?></td>
                                        <td><?= htmlspecialchars($row['ENGINE_TYPE'] ?? '—') ?></td>
                                        <td><span class="fuel-badge <?= $fuel_class ?>"><?= htmlspecialchars(strtoupper($row['FUEL_TYPE'] ?? '—')) ?></span></td>
                                        <td><?= htmlspecialchars($row['TRANSMISSION_TYPE'] ?? '—') ?></td>
                                    </tr>
                                <?php endforeach; ?>
                            </tbody>
                        </table>
                    </div>
                </div>

            <?php else: ?>
                <div class="empty-state">
                    <div class="empty-icon"><i class="bi bi-car-front"></i></div>
                    <h5>No Inventory Found</h5>
                    <p>
                        There are no available <strong><?= htmlspecialchars($search_model) ?></strong>
                        units in stock for <strong><?= htmlspecialchars($search_location) ?></strong>.
                        <br>Try a different model or region.
                    </p>
                </div>
            <?php endif; ?>
        <?php endif; ?>
    </main>

    <!-- ── FOOTER ────────────────────────────────────────────────── -->
    <footer class="site-footer">
        DriveNet Inventory Portal &nbsp;·&nbsp; Oracle + PHP OCI8 &nbsp;·&nbsp; <?= date('Y') ?>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

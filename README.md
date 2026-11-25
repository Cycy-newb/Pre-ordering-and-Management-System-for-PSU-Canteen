# PSU Canteen Ordering System — MySQL Upgrade

This version retains the original HTML/CSS pages and replaces Firebase + browser Local Storage application data with a Node/Express backend and MySQL.

## Stack
- Frontend: existing HTML, CSS, vanilla JS
- Backend: Node.js + Express
- Database: MySQL 8+ (schema uses `CHECK` constraints)

## Setup
1. Install MySQL 8+ and Node.js (LTS).
2. Open MySQL Workbench or command line and run `database/schema.sql`.
3. Open a terminal in `backend/`, install dependencies: `npm install`.
4. Copy `.env.example` to `.env` and set your MySQL password.
5. Seed the demo data: `npm run seed`.
6. Start the server: `npm start`.
7. Open **http://localhost:3000** in your browser. Don't open the HTML files directly.

## Demo accounts
- Admin: `admin` / `admin123`
- Sample students: `student001` through `student040`, password `student123`

Change demo passwords before any public deployment. This is a class/demo project; API authorization and deployment hardening are not production-ready.

## Tables and relationships
- `users` — account records
- `categories` — menu categories
- `menu_items` — menu catalog, category FK, price and stock checks
- `orders` — order header, optional user FK, status and total
- `order_items` — line items, order/menu FKs and quantity/price checks
- `feedback` — user feedback, rating check

The seed script creates 40 sample records in each main table (and one extra admin user). The sample data is for demonstration; do not use it as real operational data.

## Required SQL demonstration
Run `database/required_queries.sql` after seeding. It includes a multi-table JOIN, GROUP BY/HAVING, subquery, view, transaction example, constraint test, and status sales aggregate. The constraint test is intentionally invalid and should return an error for a rating of 6.

## Business rules demonstrated
- Menu price must be positive; stock cannot be negative.
- Order-item quantity must be positive; stored unit price cannot be negative.
- Feedback rating must be 1–5.
- Order statuses are restricted to the supported values.
- Placing an order uses a transaction, locks menu rows, verifies stock, inserts order and order items, and deducts stock together. If any item is unavailable, the transaction is rolled back.

## API overview
`POST /api/register`, `POST /api/login`, `GET /api/menu`, `POST /api/menu`, `PUT /api/menu/:id`, `DELETE /api/menu/:id`, `POST /api/orders`, `GET /api/orders`, `PATCH /api/orders/:id/status`, `POST /api/feedback`, `GET /api/feedback`, `GET /api/stats`, `GET /api/health`.

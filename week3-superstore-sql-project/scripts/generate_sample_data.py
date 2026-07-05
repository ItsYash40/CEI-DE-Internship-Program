import csv
import random
from datetime import datetime, timedelta

random.seed(42)

# ---- Reference data pools (mirrors the real Superstore dataset's categories) ----
REGIONS = {
    "West": ["California", "Washington", "Oregon", "Nevada"],
    "East": ["New York", "Pennsylvania", "New Jersey", "Massachusetts"],
    "Central": ["Texas", "Illinois", "Ohio", "Michigan"],
    "South": ["Florida", "Georgia", "North Carolina", "Virginia"],
}

STATE_CITY = {
    "California": ["Los Angeles", "San Francisco", "San Diego"],
    "Washington": ["Seattle", "Spokane"],
    "Oregon": ["Portland"],
    "Nevada": ["Las Vegas"],
    "New York": ["New York City", "Buffalo"],
    "Pennsylvania": ["Philadelphia", "Pittsburgh"],
    "New Jersey": ["Newark"],
    "Massachusetts": ["Boston"],
    "Texas": ["Houston", "Dallas", "Austin"],
    "Illinois": ["Chicago"],
    "Ohio": ["Columbus", "Cleveland"],
    "Michigan": ["Detroit"],
    "Florida": ["Miami", "Orlando", "Tampa"],
    "Georgia": ["Atlanta"],
    "North Carolina": ["Charlotte"],
    "Virginia": ["Richmond"],
}

SEGMENTS = ["Consumer", "Corporate", "Home Office"]
SHIP_MODES = ["Standard Class", "Second Class", "First Class", "Same Day"]

CATEGORY_SUBCATS = {
    "Furniture": ["Bookcases", "Chairs", "Tables", "Furnishings"],
    "Office Supplies": ["Binders", "Paper", "Storage", "Art", "Labels", "Envelopes"],
    "Technology": ["Phones", "Accessories", "Machines", "Copiers"],
}

PRODUCT_NAME_STUB = {
    "Bookcases": "Bush Furniture Bookcase", "Chairs": "Hon Executive Chair",
    "Tables": "Bretford Conference Table", "Furnishings": "Eldon Desk Lamp",
    "Binders": "Avery Binder", "Paper": "Xerox Copy Paper",
    "Storage": "Fellowes Storage Box", "Art": "Newell Scissors",
    "Labels": "Avery Labels", "Envelopes": "Staples Envelope",
    "Phones": "Apple iPhone", "Accessories": "Logitech Mouse",
    "Machines": "Canon Printer", "Copiers": "Canon imageCLASS Copier",
}

FIRST_NAMES = ["Aarav", "Priya", "John", "Emily", "Wei", "Fatima", "Carlos", "Sara",
               "Liam", "Olivia", "Noah", "Ava", "Ethan", "Mia", "Lucas", "Zoe",
               "Rahul", "Anita", "David", "Laura", "Kevin", "Nina", "Omar", "Grace",
               "Ivan", "Chloe", "Ravi", "Elena", "Sam", "Tara"]
LAST_NAMES = ["Sharma", "Patel", "Smith", "Johnson", "Chen", "Khan", "Garcia", "Lopez",
              "Brown", "Davis", "Miller", "Wilson", "Moore", "Taylor", "Anderson",
              "Thomas", "Jackson", "White", "Harris", "Martin", "Clark", "Lewis",
              "Walker", "Young", "King", "Wright", "Scott", "Green", "Baker", "Adams"]

random.shuffle(FIRST_NAMES)

def random_date(start, end):
    delta = end - start
    return start + timedelta(days=random.randint(0, delta.days))

def make_customers(n=60):
    customers = []
    for i in range(1, n + 1):
        name = f"{random.choice(FIRST_NAMES)} {random.choice(LAST_NAMES)}"
        region = random.choice(list(REGIONS.keys()))
        state = random.choice(REGIONS[region])
        city = random.choice(STATE_CITY[state])
        customers.append({
            "Customer ID": f"CU-{10000+i}",
            "Customer Name": name,
            "Segment": random.choice(SEGMENTS),
            "Country": "United States",
            "City": city,
            "State": state,
            "Postal Code": random.randint(10000, 99999),
            "Region": region,
        })
    return customers

def make_products(n=45):
    products = []
    pid = 1
    for category, subcats in CATEGORY_SUBCATS.items():
        for sub in subcats:
            for _ in range(3):  # a few product variants per sub-category
                products.append({
                    "Product ID": f"PR-{2000+pid}",
                    "Category": category,
                    "Sub-Category": sub,
                    "Product Name": f"{PRODUCT_NAME_STUB[sub]} - Model {pid}",
                })
                pid += 1
    return products

def price_for_category(category):
    if category == "Technology":
        return round(random.uniform(80, 1800), 2)
    if category == "Furniture":
        return round(random.uniform(60, 1200), 2)
    return round(random.uniform(5, 250), 2)  # Office Supplies

def generate_orders(customers, products, n_orders=520):
    rows = []
    order_counter = 1
    start_date = datetime(2019, 1, 1)
    end_date = datetime(2022, 12, 31)

    # Deliberately give ~12% of customers exactly one order (for the
    # "single-order customers" business question), and skew volume so a
    # handful of customers are clearly top spenders / bottom spenders.
    single_order_customers = set(random.sample(
        [c["Customer ID"] for c in customers], k=int(len(customers) * 0.12)
    ))

    # weighted customer picks -> some customers order much more often than others
    weights = []
    for c in customers:
        if c["Customer ID"] in single_order_customers:
            weights.append(1)
        else:
            weights.append(random.choice([2, 3, 4, 5, 8, 12]))

    order_id_counter = 1
    line_item_counter = 1
    row_id = 1

    while line_item_counter <= n_orders:
        cust = random.choices(customers, weights=weights, k=1)[0]
        n_lines_this_order = 1 if cust["Customer ID"] in single_order_customers else random.choice([1, 1, 2, 3])

        order_id = f"US-{2019 + order_id_counter % 4}-{100000 + order_id_counter}"
        order_date = random_date(start_date, end_date)
        ship_mode = random.choice(SHIP_MODES)
        ship_lag = {"Same Day": 0, "First Class": 2, "Second Class": 4, "Standard Class": 6}[ship_mode]
        ship_date = order_date + timedelta(days=ship_lag)

        for _ in range(n_lines_this_order):
            if line_item_counter > n_orders and cust["Customer ID"] not in single_order_customers:
                break
            product = random.choice(products)
            base_price = price_for_category(product["Category"])
            quantity = random.randint(1, 9)
            discount = random.choice([0, 0, 0, 0.1, 0.15, 0.2, 0.3, 0.4, 0.5])
            sales = round(base_price * quantity * (1 - discount * 0.3), 2)  # discount softens price slightly
            # profit sometimes negative (mirrors real Superstore behavior on heavy discounts)
            margin = random.uniform(0.05, 0.35) - (discount * 0.6)
            profit = round(sales * margin, 2)

            rows.append({
                "Row ID": row_id,
                "Order ID": order_id,
                "Order Date": order_date.strftime("%Y-%m-%d"),
                "Ship Date": ship_date.strftime("%Y-%m-%d"),
                "Ship Mode": ship_mode,
                "Customer ID": cust["Customer ID"],
                "Customer Name": cust["Customer Name"],
                "Segment": cust["Segment"],
                "Country": cust["Country"],
                "City": cust["City"],
                "State": cust["State"],
                "Postal Code": cust["Postal Code"],
                "Region": cust["Region"],
                "Product ID": product["Product ID"],
                "Category": product["Category"],
                "Sub-Category": product["Sub-Category"],
                "Product Name": product["Product Name"],
                "Sales": sales,
                "Quantity": quantity,
                "Discount": discount,
                "Profit": profit,
            })
            row_id += 1
            line_item_counter += 1

        order_id_counter += 1

    return rows

def main():
    customers = make_customers(60)
    products = make_products()
    rows = generate_orders(customers, products, n_orders=520)

    fieldnames = ["Row ID", "Order ID", "Order Date", "Ship Date", "Ship Mode",
                  "Customer ID", "Customer Name", "Segment", "Country", "City",
                  "State", "Postal Code", "Region", "Product ID", "Category",
                  "Sub-Category", "Product Name", "Sales", "Quantity", "Discount", "Profit"]

    with open("/home/claude/superstore-sql-project/data/superstore.csv", "w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)

    print(f"Generated {len(rows)} order line-items for {len(customers)} customers and {len(products)} products.")

if __name__ == "__main__":
    main()

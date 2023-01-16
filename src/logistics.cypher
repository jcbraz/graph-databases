MERGE (p:Producer {name: "Soprema"})
MERGE (d1:Distributor {name: "Reconco", region: "Bragança"})
MERGE (d2:Distributor {name: "Tib", region: "Vila Nova de Famalicão"})
MERGE (d3:Distributor {name: "BragaSom", region: "Braga"})
MERGE (d4:Distributor {name: "VazConstroi", region: "Vila Real"})
MERGE (d5:Distributor {name: "MC Group", region: "Marco De Canavezes"})
MERGE (r1:Retailer {name: "BragaMateriais", region: "Braga"})
MERGE (r2:Retailer {name: "Leroy Merlin", region: "Braga"})
MERGE (r3:Retailer {name: "Melon Obras", region: "Braga"})
MERGE (r4:Retailer {name: "Braga Constroi", region: "Braga"})
MERGE (r5:Retailer {name: "VianaConstroi", region: "Viana Do Castelo"})
MERGE (r6:Retailer {name: "MatMateriais", region: "Viana Do Castelo"})
MERGE (r7:Retailer {name: "Viana Group", region: "Viana Do Castelo"})
MERGE (r8:Retailer {name: "DC Group", region: "Bragança"})
MERGE (r9:Retailer {name: "Altura CO", region: "Bragança"})
MERGE (r10:Retailer {name: "MonteMateriais", region: "Bragança"})
MERGE (r11:Retailer {name: "VR Group", region: "Vila Real"})
MERGE (r12:Retailer {name: "Vila Construções", region: "Vila Real"})

MATCH (p:Producer {name: "Soprema"}), (d:Distributor)
WHERE d.name IN ["Reconco", "Tib", "BragaSom", "VazConstroi", "MC Group"]
MERGE (p)-[:SELLS_TO {material: ["xps", "glass fiber"]}]->(d)

MATCH (d:Distributor), (r:Retailer)
WHERE d.region = r.region
WITH d, r, count(*) as current_distributors
WHERE current_distributors < 2
MERGE (d)-[:DISTRIBUTES_TO]->(r)

MATCH (d:Distributor) WHERE d.name="Reconco" SET d.order=3000
MATCH (d:Distributor) WHERE d.name="Reconco" SET d.price=1.1
MATCH (r:Retailer) WHERE r.name="DC Group" SET r.order=1000
MATCH (r:Retailer) WHERE r.name="DC Group" SET r.price=1.4
MATCH (r:Retailer) WHERE r.name="MonteMateriais" SET r.order=1000
MATCH (r:Retailer) WHERE r.name="MonteMateriais" SET r.price=1.5
MATCH (r:Retailer) WHERE r.name="Altura CO" SET r.order=1000
MATCH (r:Retailer) WHERE r.name="Altura CO" SET r.price=1.55

MATCH (d:Distributor{name: "Reconco"}), (r:Retailer)
WHERE d.region = r.region
RETURN r.name, (r.order * r.price) - (d.order/3 * d.price)
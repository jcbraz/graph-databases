(async() => {
    const neo4j = require('neo4j-driver');

    const uri = 'neo4j+s://0648d012.databases.neo4j.io';
    const user = 'neo4j';
    const password = 'L4C-Hmbodv2nWRq58FYXU4oRT0PJg1imgISr9nLJ_z0';
    
    // To learn more about the driver: https://neo4j.com/docs/javascript-manual/current/client-applications/#js-driver-driver-object
    const driver = neo4j.driver(uri, neo4j.auth.basic(user, password));

    try {
        const distributor = 'Reconco'
        const retailer1 = 'DC Group';
        const retailer2 = 'Altura CO';
        const retailer3 = 'MonteMateriais';

        await createRelationship(driver, distributor, retailer1);
        await createRelationship(driver, distributor, retailer2);
        await createRelationship(driver, distributor, retailer3);

    } catch (error) {
        console.error(`Something went wrong: ${error}`);
    } finally {
        // Don't forget to close the driver connection when you're finished with it.
        await driver.close();
    }

    async function createRelationship (driver, distributor , retailer) {

        const session = driver.session({ database: 'neo4j' });

        try {
            const writeQuery = `MATCH (d:Distributor), (r:Retailer)
                                WHERE d.region = r.region
                                WITH d, r, count(*) as current_distributors
                                WHERE current_distributors < 2
                                MERGE (d)-[:DISTRIBUTES_TO]->(r)`

            const writeResult = await session.executeWrite(tx =>
                tx.run(writeQuery, { distributor, retailer })
            );

            writeResult.records.forEach(record => {
                const distributorNode = record.get('d');
                const retailerNode = record.get('r');
                console.log(`Created relation between: ${distributorNode.properties.name}, ${retailerNode.properties.name}`);
            });

        } catch (error) {
            console.error(`Something went wrong: ${error}`);
        } finally {
            await session.close();
        }
    }

});

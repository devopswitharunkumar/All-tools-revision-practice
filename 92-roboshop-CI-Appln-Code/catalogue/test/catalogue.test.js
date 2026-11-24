
const request = require('supertest');
const app = require('../server');

describe('Catalogue API Unit Tests', () => {

    let collection;
    let sampleProducts;

    beforeEach(() => {

        sampleProducts = [
            {
                sku: 'HAL-1',
                name: 'HAL',
                price: 2001,
                categories: ['Artificial Intelligence']
            },
            {
                sku: 'ROB-1',
                name: 'Robbie',
                price: 1200,
                categories: ['Robot']
            }
        ];

        collection = {
            find: jest.fn(),
            findOne: jest.fn(),
            distinct: jest.fn()
        };

        // Mock MongoDB state for testing
        app.locals.mongoConnected = true;
        app.locals.collection = collection;
    });

    test('GET /health should return application health', async () => {

        const response = await request(app).get('/health');

        expect(response.status).toBe(200);
        expect(response.body.app).toBe('OK');
        expect(response.body.mongo).toBe(true);

    });

    test('GET /healthcheck should return OKK', async () => {

        const response = await request(app).get('/healthcheck');

        expect(response.status).toBe(200);
        expect(response.body.app).toBe('OKK');

    });

    test('GET /products should return all products', async () => {

        collection.find.mockReturnValue({
            toArray: jest.fn().mockResolvedValue(sampleProducts)
        });

        const response = await request(app).get('/products');

        expect(response.status).toBe(200);
        expect(response.body).toHaveLength(2);
        expect(response.body[0].sku).toBe('HAL-1');

    });

    test('GET /product/:sku should return product by SKU', async () => {

        collection.findOne.mockResolvedValue(sampleProducts[0]);

        const response = await request(app).get('/product/HAL-1');

        expect(response.status).toBe(200);
        expect(response.body.sku).toBe('HAL-1');

        expect(collection.findOne)
            .toHaveBeenCalledWith({ sku: 'HAL-1' });

    });

    test('GET /product/:sku should return 404 for unknown SKU', async () => {

        collection.findOne.mockResolvedValue(null);

        const response = await request(app).get('/product/UNKNOWN');

        expect(response.status).toBe(404);
        expect(response.text).toBe('SKU not found');

    });

    test('GET /products/:cat should return category products', async () => {

        const toArray = jest.fn().mockResolvedValue([sampleProducts[1]]);

        const sort = jest.fn().mockReturnValue({ toArray });

        collection.find.mockReturnValue({ sort });

        const response = await request(app).get('/products/Robot');

        expect(response.status).toBe(200);
        expect(response.body[0].name).toBe('Robbie');

        expect(collection.find)
            .toHaveBeenCalledWith({ categories: 'Robot' });

        expect(sort).toHaveBeenCalledWith({ name: 1 });

    });

    test('GET /categories should return all categories', async () => {

        collection.distinct.mockResolvedValue([
            'Artificial Intelligence',
            'Robot'
        ]);

        const response = await request(app).get('/categories');

        expect(response.status).toBe(200);
        expect(response.body).toContain('Robot');
        expect(response.body).toContain('Artificial Intelligence');

    });

    test('GET /search/:text should return matching products', async () => {

        collection.find.mockReturnValue({
            toArray: jest.fn().mockResolvedValue([sampleProducts[0]])
        });

        const response = await request(app).get('/search/HAL');

        expect(response.status).toBe(200);
        expect(response.body[0].sku).toBe('HAL-1');

        expect(collection.find).toHaveBeenCalledWith({
            '$text': {
                '$search': 'HAL'
            }
        });

    });

    test('GET /products should return 500 when MongoDB is unavailable', async () => {

        app.locals.mongoConnected = false;

        const response = await request(app).get('/products');

        expect(response.status).toBe(500);

    });

});

// const mongoClient = require('mongodb').MongoClient;
// const mongoObjectID = require('mongodb').ObjectID;
// const bodyParser = require('body-parser');
// const express = require('express');
// const pino = require('pino');
// const expPino = require('express-pino-logger');

// const logger = pino({
//     level: 'info',
//     prettyPrint: false,
//     useLevelLabels: true
// });
// const expLogger = expPino({
//     logger: logger
// });

// // MongoDB
// var db;
// var collection;
// var mongoConnected = false;

// const app = express();

// app.use(expLogger);

// app.use((req, res, next) => {
//     res.set('Timing-Allow-Origin', '*');
//     res.set('Access-Control-Allow-Origin', '*');
//     next();
// });

// app.use(bodyParser.urlencoded({ extended: true }));
// app.use(bodyParser.json());

// app.get('/health', (req, res) => {
//     var stat = {
//         app: 'OK',
//         mongo: mongoConnected
//     };
//     res.json(stat);
// });
// //Developer added new feature here and version updated to 1.2.0
// app.get('/healthcheck', (req, res) => {
//     var stat1 = {
//         app: 'OKK',
//         mongo: mongoConnected
//     };
//     res.json(stat1);
// });

// // all products
// app.get('/products', (req, res) => {
//     if(mongoConnected) {
//         collection.find({}).toArray().then((products) => {
//             res.json(products);
//         }).catch((e) => {
//             req.log.error('ERROR', e);
//             res.status(500).send(e);
//         });
//     } else {
//         req.log.error('database not available');
//         res.status(500).send('database not avaiable');
//     }
// });

// //new features added to catalogue application and updated the version 1.0.1

// // product by SKU
// app.get('/product/:sku', (req, res) => {
//     if(mongoConnected) {
//         // optionally slow this down
//         const delay = process.env.GO_SLOW || 0;
//         setTimeout(() => {
//         collection.findOne({sku: req.params.sku}).then((product) => {
//             req.log.info('product', product);
//             if(product) {
//                 res.json(product);
//             } else {
//                 res.status(404).send('SKU not found');
//             }
//         }).catch((e) => {
//             req.log.error('ERROR', e);
//             res.status(500).send(e);
//         });
//         }, delay);
//     } else {
//         req.log.error('database not available');
//         res.status(500).send('database not available');
//     }
// });

// // products in a category
// app.get('/products/:cat', (req, res) => {
//     if(mongoConnected) {
//         collection.find({ categories: req.params.cat }).sort({ name: 1 }).toArray().then((products) => {
//             if(products) {
//                 res.json(products);
//             } else {
//                 res.status(404).send('No products for ' + req.params.cat);
//             }
//         }).catch((e) => {
//             req.log.error('ERROR', e);
//             res.status(500).send(e);
//         });
//     } else {
//         req.log.error('database not available');
//         res.status(500).send('database not avaiable');
//     }
// });

// // all categories
// app.get('/categories', (req, res) => {
//     if(mongoConnected) {
//         collection.distinct('categories').then((categories) => {
//             res.json(categories);
//         }).catch((e) => {
//             req.log.error('ERROR', e);
//             res.status(500).send(e);
//         });
//     } else {
//         req.log.error('database not available');
//         res.status(500).send('database not available');
//     }
// });

// // search name and description
// app.get('/search/:text', (req, res) => {
//     if(mongoConnected) {
//         collection.find({ '$text': { '$search': req.params.text }}).toArray().then((hits) => {
//             res.json(hits);
//         }).catch((e) => {
//             req.log.error('ERROR', e);
//             res.status(500).send(e);
//         });
//     } else {
//         req.log.error('database not available');
//         res.status(500).send('database not available');
//     }
// });

// if (process.env.MONGO == 'true') {
// // set up Mongo
// function mongoConnect() {
//     return new Promise((resolve, reject) => {
//         var mongoURL = process.env.MONGO_URL || 'mongodb://mongodb:27017/catalogue';
//         mongoClient.connect(mongoURL, (error, client) => {
//             if(error) {
//                 reject(error);
//             } else {
//                 db = client.db('catalogue');
//                 collection = db.collection('products');
//                 resolve('connected');
//             }
//         });
//     });
// }
// }

// if (process.env.DOCUMENTDB == 'true') {
// function mongoConnect() {
//     return new Promise((resolve, reject) => {
//     var mongoURL = process.env.MONGO_URL || 'mongodb://username:password@mongodb:27017/catalogue?tls=true&replicaSet=rs0&readPreference=secondaryPreferred&retryWrites=false';
//     var client = mongoClient.connect(mongoURL,
//       {
//         // Mutable & Immutable
//         //tlsCAFile: `/home/roboshop/catalogue/rds-combined-ca-bundle.pem` //Specify the DocDB; cert
//         // Container
//         tlsCAFile: `/app/rds-combined-ca-bundle.pem` //Specify the DocDB; cert
//     }, (error, client) => {
//     if(error) {
//         reject(error);
//     } else {
//         db = client.db('catalogue');
//         collection = db.collection('products');
//         resolve('connected');
//     }
// });
// });
// }
// }


// // mongodb connection retry loop
// function mongoLoop() {
//     mongoConnect().then((r) => {
//         mongoConnected = true;
//         logger.info('MongoDB connected');
//     }).catch((e) => {
//         logger.error('ERROR', e);
//         setTimeout(mongoLoop, 2000);
//     });
// }

// mongoLoop();

// // fire it up!
// const port = process.env.CATALOGUE_SERVER_PORT || '8080';
// const MONGO = process.env.MONGO || 'false';
// const DOCUMENTDB = process.env.DOCUMENTDB || 'false';

// app.listen(port, () => {
//     logger.info('Started on port', port);
// });



const mongoClient = require('mongodb').MongoClient;
const bodyParser = require('body-parser');
const express = require('express');
const pino = require('pino');
const expPino = require('express-pino-logger');

const logger = pino({
    level: 'info',
    prettyPrint: false,
    useLevelLabels: true
});

const expLogger = expPino({
    logger: logger
});

// MongoDB
var db;

const app = express();

// Application state
app.locals.mongoConnected = false;
app.locals.collection = null;

app.use(expLogger);

app.use((req, res, next) => {
    res.set('Timing-Allow-Origin', '*');
    res.set('Access-Control-Allow-Origin', '*');
    next();
});

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

// Health API
app.get('/health', (req, res) => {
    var stat = {
        app: 'OK',
        mongo: app.locals.mongoConnected
    };

    res.json(stat);
});

// Healthcheck API
app.get('/healthcheck', (req, res) => {
    var stat1 = {
        app: 'OKK',
        mongo: app.locals.mongoConnected
    };

    res.json(stat1);
});

// All products
app.get('/products', (req, res) => {
    if (app.locals.mongoConnected) {
        app.locals.collection.find({}).toArray()
            .then((products) => {
                res.json(products);
            })
            .catch((e) => {
                req.log.error('ERROR', e);
                res.status(500).send(e.message);
            });
    } else {
        req.log.error('database not available');
        res.status(500).send('database not available');
    }
});

// Product by SKU
app.get('/product/:sku', (req, res) => {
    if (app.locals.mongoConnected) {
        const delay = process.env.GO_SLOW || 0;

        setTimeout(() => {
            app.locals.collection.findOne({
                sku: req.params.sku
            })
                .then((product) => {
                    req.log.info('product', product);

                    if (product) {
                        res.json(product);
                    } else {
                        res.status(404).send('SKU not found');
                    }
                })
                .catch((e) => {
                    req.log.error('ERROR', e);
                    res.status(500).send(e.message);
                });
        }, delay);
    } else {
        req.log.error('database not available');
        res.status(500).send('database not available');
    }
});

// Products in a category
app.get('/products/:cat', (req, res) => {
    if (app.locals.mongoConnected) {
        app.locals.collection.find({
            categories: req.params.cat
        }).sort({ name: 1 }).toArray()
            .then((products) => {
                res.json(products);
            })
            .catch((e) => {
                req.log.error('ERROR', e);
                res.status(500).send(e.message);
            });
    } else {
        req.log.error('database not available');
        res.status(500).send('database not available');
    }
});

// All categories
app.get('/categories', (req, res) => {
    if (app.locals.mongoConnected) {
        app.locals.collection.distinct('categories')
            .then((categories) => {
                res.json(categories);
            })
            .catch((e) => {
                req.log.error('ERROR', e);
                res.status(500).send(e.message);
            });
    } else {
        req.log.error('database not available');
        res.status(500).send('database not available');
    }
});

// Search products
app.get('/search/:text', (req, res) => {
    if (app.locals.mongoConnected) {
        app.locals.collection.find({
            '$text': {
                '$search': req.params.text
            }
        }).toArray()
            .then((hits) => {
                res.json(hits);
            })
            .catch((e) => {
                req.log.error('ERROR', e);
                res.status(500).send(e.message);
            });
    } else {
        req.log.error('database not available');
        res.status(500).send('database not available');
    }
});

// MongoDB connection
function mongoConnect() {
    return new Promise((resolve, reject) => {
        var mongoURL = process.env.MONGO_URL ||
            'mongodb://mongodb:27017/catalogue';

        mongoClient.connect(mongoURL, (error, client) => {
            if (error) {
                reject(error);
            } else {
                db = client.db('catalogue');

                app.locals.collection = db.collection('products');
                app.locals.mongoConnected = true;

                resolve('connected');
            }
        });
    });
}

// MongoDB connection retry loop
function mongoLoop() {
    mongoConnect()
        .then(() => {
            logger.info('MongoDB connected');
        })
        .catch((e) => {
            logger.error('ERROR', e);
            setTimeout(mongoLoop, 2000);
        });
}

// Export Express app for unit testing
module.exports = app;

// Start actual server only when executed directly
if (require.main === module) {

    // Connect to MongoDB only during actual application startup
    mongoLoop();

    const port = process.env.CATALOGUE_SERVER_PORT || '8080';

    app.listen(port, () => {
        logger.info('Started on port', port);
    });
}

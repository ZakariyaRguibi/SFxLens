import express from 'express';
import flowController from '../controllers/flowController';
import apexController from '../controllers/apexController';
import logController from '../controllers/logController';

const router = express.Router();

// Flow routes
router.get('/flows', flowController.getFlows);

// Apex routes
router.get('/apex/triggers', apexController.getTriggers);
router.get('/apex/classes', apexController.getClasses);

// Log routes
router.get('/logs', logController.getLogs);
router.get('/logs/:id', logController.getLogById);
router.post('/logs/analyze', logController.analyzeLog);

export default router;

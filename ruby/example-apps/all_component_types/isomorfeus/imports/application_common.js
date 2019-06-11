import * as Redux from 'redux';
import React from 'react';
import * as ReactRouter from 'react-router';
import * as ReactRouterDOM from 'react-router-dom';
import * as Mui from '@material-ui/core'
import * as MuiStyles from '@material-ui/styles'
global.Redux = Redux;
global.React = React;
global.ReactRouter = ReactRouter;
global.ReactRouterDOM = ReactRouterDOM;
global.Mui = Mui;
global.MuiStyles = MuiStyles;

if (module.hot) { module.hot.accept(); }

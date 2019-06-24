/**
 * @file src/lib/axios.js
 * @copyright 2019-present Karim Alibhai. All rights reserved.
 */

import axiosMod from 'axios'

export const axios = axiosMod.create({
	crossDomain: true,
	withCredentials: true,
	baseURL: 'http://localhost:8080/api',
})

export function setAuthToken(token) {
	axios.defaults.headers.Authorization = token

	if (token) {
		localStorage.setItem('authToken', token)
	} else {
		localStorage.removeItem('authToken')
	}
}

export function getAuthToken() {
	return localStorage.getItem('authToken')
}

const storedToken = localStorage.getItem('authToken')
if (storedToken) {
	setAuthToken(storedToken)
}

axios.interceptors.response.use(
	res => res,
	err => {
		if (
			!err.config.url.endsWith('/api/users/login') &&
			err.response &&
			err.response.status === 401
		) {
			location.href = '/login'
		}

		return Promise.reject(err)
	},
)

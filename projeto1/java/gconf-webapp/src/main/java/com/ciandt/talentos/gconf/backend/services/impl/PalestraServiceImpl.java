package com.ciandt.talentos.gconf.backend.services.impl;

import java.util.List;

import javax.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ciandt.talentos.gconf.backend.dao.PalestraRepository;
import com.ciandt.talentos.gconf.backend.entities.Palestra;
import com.ciandt.talentos.gconf.backend.services.PalestraService;

@Service
@Transactional
public class PalestraServiceImpl implements PalestraService {
	
	@Autowired
	private PalestraRepository palestraRepository;
	
	@Override
	public List<Palestra> findPalestrasByTituloAndPalestranteIdNoRequered(String titulo, Long palestranteId) {
		
		palestranteId = palestranteId == null ? Long.valueOf("0") : palestranteId;
		
		return palestraRepository.findByTituloAndPalestranteIdNoRequered(titulo, palestranteId);
	}
}

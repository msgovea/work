package com.ciandt.talentos.gconf.backend.dto;

import java.sql.Timestamp;

import com.ciandt.talentos.gconf.backend.entities.Conferencia;


public class ConferenciaDTO {

	private Long id;
	private String organizador;
	private String titulo;
	private Timestamp dataIni;
	private Timestamp dataFim;
	private String assunto;
	
	public ConferenciaDTO() {}
	
	public ConferenciaDTO(Conferencia entity){
		this.id = entity.getId();
		this.titulo = entity.getTitulo();
		this.organizador = entity.getOrganizador();
		this.assunto = entity.getAssunto();
		this.dataIni = entity.getDataIni();
		this.dataFim = entity.getDataFim();
	}
	
	public Conferencia toEntity() {
		return new Conferencia(getId(), getOrganizador(), getTitulo(),getAssunto(), getDataIni(), getDataFim());
	}
	
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getOrganizador() {
		return organizador;
	}

	public String getTitulo() {
		return titulo;
	}

	public void setOrganizador(String organizador) {
		this.organizador = organizador;
	}

	public void setTitulo(String titulo) {
		this.titulo = titulo;
	}

	public void setDataIni(Timestamp dataIni) {
		this.dataIni = dataIni;
	}

	public void setDataFim(Timestamp dataFim) {
		this.dataFim = dataFim;
	}

	public Timestamp getDataIni() {
		return dataIni;
	}

	public Timestamp getDataFim() {
		return dataFim;
	}

	public String getAssunto() {
		return assunto;
	}

	public void setAssunto(String assunto) {
		this.assunto = assunto;
	}
	
	
	
}

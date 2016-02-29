package com.ciandt.talentos.gconf.backend.entities;

import java.sql.Timestamp;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

@Entity
@Table(name = "GC_CONFERENCIA")
public class Conferencia {
	
	
	@Id
	@SequenceGenerator(name="GC_CONFERENCIA_SEQ")
	@Column(name="ID", nullable=false)
	private int id;
	
	@Column(name="TITULO", nullable=false)
	private String titulo;
	
	@Column(name="ASSUNTO", nullable=false)
	private String assunto;
	
	@Column(name="ORGANIZADOR", nullable=false)
	private String organizador;
	
	@Column(name="DATA_INICIO", nullable=false)
	private Timestamp dateInicio;
	
	@Column(name="DATA_FIM", nullable=false)
	private Timestamp dataFim;
	
	public Conferencia() {};

	public Conferencia(int id, String titulo, String assunto,
			String organizador, Timestamp dateInicio, Timestamp dataFim) {
		super();
		this.id = id;
		this.titulo = titulo;
		this.assunto = assunto;
		this.organizador = organizador;
		this.dateInicio = dateInicio;
		this.dataFim = dataFim;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getTitulo() {
		return titulo;
	}

	public void setTitulo(String titulo) {
		this.titulo = titulo;
	}

	public String getAssunto() {
		return assunto;
	}

	public void setAssunto(String assunto) {
		this.assunto = assunto;
	}

	public String getOrganizador() {
		return organizador;
	}

	public void setOrganizador(String organizador) {
		this.organizador = organizador;
	}

	public Timestamp getDateInicio() {
		return dateInicio;
	}

	public void setDateInicio(Timestamp dateInicio) {
		this.dateInicio = dateInicio;
	}

	public Timestamp getDataFim() {
		return dataFim;
	}

	public void setDataFim(Timestamp dataFim) {
		this.dataFim = dataFim;
	}
	
	

	
	
	
	
	
	
	
}
